
path = '.\kicker_dslr_undistorted (ONLY FOR DEBUGGING)\kicker\dslr_calibration_undistorted\points3D.txt';

global_coordinates = get_global_coordinates_list_test(path);

%scatter3(global_coordinates(1,:),global_coordinates(2,:), global_coordinates(3,:))

% Create a sample point cloud data in a list format
point_cloud_data = global_coordinates;
% [
%     1.2, 3.4, 2.1;
%     2.3, 1.5, 4.2;
%     5.6, 2.4, 3.1;
%     2.0, 4.7, 1.8;
%     % Add more points as needed
% ];



% Parameters
maxClusters = 50; % Maximum number of clusters to consider
maxIterations = 200; % Maximum number of iterations for k-means
distances = zeros(maxClusters, 1);

% Calculate the sum of squared distances for different number of clusters
for k = 1:maxClusters
    centroids = initializeCentroids(point_cloud_data, k);
    [~, sumd] = runKMeans(point_cloud_data, centroids, maxIterations);
    distances(k) = sum(sumd);
end

% Plot the elbow curve
figure;
plot(1:maxClusters, distances, 'o-');
title('Elbow Curve');
xlabel('Number of Clusters');
ylabel('Sum of Squared Distances');

% Prompt the user to select the optimal number of clusters
numClusters = input('Select the optimal number of clusters: ');

% Perform clustering using k-means algorithm
centroids = initializeCentroids(point_cloud_data, numClusters);
[idx, ~] = runKMeans(point_cloud_data, centroids, maxIterations);

% Plot the results
figure;
scatter3(point_cloud_data(:,1), point_cloud_data(:,2), point_cloud_data(:,3), 36, idx, 'filled');
title('Point Cloud Clustering');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;

function centroids = initializeCentroids(data, k)
    numPoints = size(data, 1);
    randIndices = randperm(numPoints, k);
    centroids = data(randIndices, :);
end

function [idx, sumd] = runKMeans(data, centroids, maxIterations)
    numClusters = size(centroids, 1);
    numPoints = size(data, 1);
    idx = zeros(numPoints, 1);
    sumd = zeros(numClusters, 1);
    
    for iter = 1:maxIterations
        % Assign points to the nearest cluster
        distances = calculateDistances(data, centroids);
        [~, newIdx] = min(distances, [], 2);
        
        % Update cluster centroids
        for k = 1:numClusters
            clusterPoints = data(newIdx == k, :);
            centroids(k, :) = mean(clusterPoints);
        end
        
        if isequal(idx, newIdx)
            break;
        end
        
        idx = newIdx;
    end
    
    % Calculate the sum of squared distances
    for k = 1:numClusters
        clusterPoints = data(idx == k, :);
        sumd(k) = sum(sum((clusterPoints - centroids(k, :)).^2, 2));
    end
end

function distances = calculateDistances(data, centroids)
    numPoints = size(data, 1);
    numClusters = size(centroids, 1);
    distances = zeros(numPoints, numClusters);
    
    for k = 1:numClusters
        centroid = centroids(k, :);
        differences = bsxfun(@minus, data, centroid);
        distances(:, k) = sqrt(sum(differences.^2, 2));
    end
end


function global_coordinates = get_global_coordinates_list_test(path)
    no_lines = count_lines(path);
    no_coords = no_lines - 3;

    fid = fopen(path);
    tline = fgets(fid);
    while ischar(tline)
        elems = strsplit(tline);
        if numel(elems) < 4 || strcmp(elems(1), '#')
            tline = fgets(fid);
            continue
        else
            break;
        end 
    end

    global_coordinates = zeros(no_coords, 3);
    
    i = 1;
    while ischar(tline)
        elems = strsplit(tline);
        X = str2double(elems{2});
        Y = str2double(elems{3});
        Z = str2double(elems{4});
        tline = fgets(fid);
        global_coordinates(i, 1) = X;
        global_coordinates(i, 2) = Y;
        global_coordinates(i, 3) = Z;
        i = i + 1;
    end

    fclose(fid);
end

function no_lines = count_lines(path)
    lineNumber = 0;
    lastElementLine = 0;
    fid = fopen(path);
    % Read the file line by line until the end
    while ~feof(fid)
        lineNumber = lineNumber + 1;
        line = fgetl(fid);
        if ~isempty(line)
            lastElementLine = lineNumber;
        end
    end

    fclose(fid);

    no_lines = lastElementLine;
end