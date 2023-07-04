
clc;
clear;

path = '.\delivery_area_dslr_undistorted (ONLY FOR DEBUGGING)\delivery_area\dslr_calibration_undistorted\points3D.txt';

global_coordinates = get_global_coordinates_list_test(path);

%scatter3(global_coordinates(1,:),global_coordinates(2,:), global_coordinates(3,:))

% Create a sample point cloud data in a list format
data = global_coordinates;

floor_level = find_floor_level(data)
% [
%     1.2, 3.4, 2.1;
%     2.3, 1.5, 4.2;
%     5.6, 2.4, 3.1;
%     2.0, 4.7, 1.8;
%     % Add more points as needed
% ];



[idx, corepoints] = dbscan(data, 0.2, 20);
numObjects = length(unique(idx)) - 1;

max_room = max(data(idx ~= -1, 1:2))
min_room = min(data(idx ~= -1, 1:2))



min_list = zeros(3,numObjects)';
max_list = zeros(3,numObjects)';
for i = 1:numObjects
    points_i = data(idx==i, :);
    max_list(i, :) = max(points_i);
    min_list(i, :) = min(points_i);
end

senterliste = zeros(numObjects, 3);
lengdeliste = zeros(numObjects, 3);
for i = 1:numObjects
    O = (min_list(i, :) + max_list(i, :))/2;
    lenX = max_list(i, 1) - min_list(i, 1);
    lenY = max_list(i, 2) - min_list(i, 2);
    lenZ = max_list(i, 3) - min_list(i, 3);
    lengder = [lenX, lenY, lenZ];
    senterliste(i, :) = O;
    lengdeliste(i ,:) = lengder;
end

figure
hold on;
for i = 1:numObjects
    drawBox(senterliste(i,:), lengdeliste(i,:));
end

X = [min_room(1), min_room(1), max_room(1), max_room(1)];
Y = [min_room(2), max_room(2), max_room(2), min_room(2)];
Z = [floor_level, floor_level, floor_level, floor_level];


patch('XData', X, 'YData', Y, 'ZData', Z);




% % % for i = 1:size(data, 1)
% % %     if (idx(i) == -1)
% % %         continue
% % %         % plot3(data(i, 1), data(i, 2), data(i, 3), 'r+', 'MarkerSize', 10);
% % %         % hold on;
% % %     else
% % %         if (corepoints(i) == 1)
% % %             plot3(data(i, 1), data(i, 2), data(i, 3), 'b.', 'MarkerSize', 10);
% % %         else
% % %             plot3(data(i, 1), data(i, 2), data(i, 3), 'g*', 'MarkerSize', 10);
% % %         end
% % %         hold on;
% % %     end
% % % 
% % %     if mod(i, 1000) == 0
% % %         i
% % %     end
% % % end
hold off;



% % % % % % % Set the maximum desired distance between points within clusters
% % % % % % maxDistance = 2.0;
% % % % % % 
% % % % % % % Calculate the pairwise distances between points using vectorization
% % % % % % numPoints = size(point_cloud_data, 1);
% % % % % % distances = sqrt(sum((reshape(point_cloud_data, [1, numPoints, 3]) - reshape(point_cloud_data, [numPoints, 1, 3])).^2, 3));
% % % % % % 
% % % % % % % Perform agglomerative hierarchical clustering
% % % % % % clusters = 1:numPoints;
% % % % % % clusterCount = numPoints
% % % % % % a = 0;
% % % % % % 
% % % % % % while clusterCount > 1
% % % % % %     [minDistance, minIndex] = min(distances(:));
% % % % % %     [row, col] = ind2sub([numPoints, numPoints], minIndex);
% % % % % % 
% % % % % %     if minDistance > maxDistance
% % % % % %         break;
% % % % % %     end
% % % % % % 
% % % % % %     clusters(clusters == clusters(col)) = clusters(row);
% % % % % %     clusterCount = clusterCount - 1;
% % % % % % 
% % % % % %     distances([row, col], :) = maxDistance + 1; % Set distances to a large value
% % % % % %     distances(:, [row, col]) = maxDistance + 1;
% % % % % % 
% % % % % %     for j = 1:numPoints
% % % % % %         if clusters(j) == clusters(row)
% % % % % %             distances(row, j) = min(distances(row, j), distances(col, j));
% % % % % %             distances(j, row) = distances(row, j);
% % % % % %         end
% % % % % %     end
% % % % % %     a = a + 1;
% % % % % %     if mod(a, 100) == 0
% % % % % %         a
% % % % % %     end
% % % % % % end
% % % % % % 
% % % % % % % Plot the results
% % % % % % figure;
% % % % % % scatter3(point_cloud_data(:,1), point_cloud_data(:,2), point_cloud_data(:,3), 36, clusters, 'filled');
% % % % % % title('Point Cloud Clustering');
% % % % % % xlabel('X');
% % % % % % ylabel('Y');
% % % % % % zlabel('Z');
% % % % % % grid on;



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


function drawBox(origin, sideLengths)
    % Extract coordinates of the origin
    x = origin(1);
    y = origin(2);
    z = origin(3);
    
    % Extract side lengths
    sideLengthX = sideLengths(1);
    sideLengthY = sideLengths(2);
    sideLengthZ = sideLengths(3);
    
    % Define the vertices of the box
    vertices = [
        x, y, z;                        % Vertex 1
        x + sideLengthX, y, z;          % Vertex 2
        x + sideLengthX, y + sideLengthY, z;  % Vertex 3
        x, y + sideLengthY, z;          % Vertex 4
        x, y, z + sideLengthZ;          % Vertex 5
        x + sideLengthX, y, z + sideLengthZ;  % Vertex 6
        x + sideLengthX, y + sideLengthY, z + sideLengthZ;  % Vertex 7
        x, y + sideLengthY, z + sideLengthZ   % Vertex 8
    ];

    % Define the faces of the box
    faces = [
        1, 2, 3, 4;    % Bottom face
        5, 6, 7, 8;    % Top face
        1, 2, 6, 5;    % Side face
        2, 3, 7, 6;    % Side face
        3, 4, 8, 7;    % Side face
        4, 1, 5, 8     % Side face
    ];

    % Plot the box
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'blue', 'FaceAlpha', 0.5);
    axis equal;
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Box');
end

%%Funksjonen gir ikke floo level
function floor_level = find_floor_level(data)
    minimum_floor = -10.;
    maximum_floor = 10.;
    delta_z = 0.05;
    z = minimum_floor:delta_z:maximum_floor;
    last_count = 0;
    floor_level = minimum_floor;
    for i = 1:(length(z)-1)
        count = length(data(data(:, 3) < z(i+1))) - length(data(data(:, 3) <= z(i)));
        if count < 30
            last_count = count;
            continue;
        else
            if count/last_count > 10
                floor_level = z(i);
                break;
            end
        end
    end
end