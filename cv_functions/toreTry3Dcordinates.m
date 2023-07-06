%%
% Specify the path to the subfolder containing the images
subfolderPath = ".\test_data_kicker\images";

% Get a list of all files and folders in the subfolder
files = dir(fullfile(subfolderPath, '*.JPG'));  % Modify the file extension as needed

% Preallocate an array to store the image file names
imageFiles = cell(numel(files), 1);

% Store the file names in the array. THEY ARE ACTUALLY SORTED!
for i = 1:numel(files)
    imageFiles{i} = fullfile(subfolderPath, files(i).name);
end

%Calibration matrix for the kicker
K_path = ".\test_data_kicker\parameters";
[K] = K_from_cameraparams(K_path);

allData = readmatrix(".\test_data_kicker\parameters\images.txt");
cam_pos_unsorted = allData(:, 1:4);
[cam_pos_sorted,sort_index] = sortrows(cam_pos_unsorted);
imageFiles = imageFiles(sort_index);

image = im2gray(imread(imageFiles{1}));
imageSize = size(image);
focalLength = [K(1,1) K(2,2)];
principalPoint = [K(1,3) K(2,3)];
intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);

%% Her er koden du trenger for å kjøre, alt over er bare lagt til for å få det til å kjøre
[features,valid] = find_features(imageFiles);
[tree, matches] = find_match_tree(features,valid, imageFiles);
sequence = findCompletedSequence(tree, 1);
disp(sequence);
%%
%Bare sortering av bildene og kameraposisjonene, sortering av bilder tror
%jeg ikke trengs
imageFiles = imageFiles(sequence');
cam_pos_sorted = cam_pos_unsorted(sequence,:);

%%
relPose_cell = cell(1,size(imageFiles,1)-1);
points3D_all = [];
for i = 1:size(imageFiles,1)-2 % Usikker på hvorfor det må være -2 og ikke -1, virker som at siste bildet ikke blir sortert
    %Regn ut 3D kordinater
    matchedPoints1 = matches{sequence(i),sequence(i+1)};
    matchedPoints2 = matches{sequence(i+1),sequence(i)};
    [E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, 'Confidence', 99.99);

    % Find epipolar inliers
    inlierPoints1 = matchedPoints1(epipolarInliers, :);
    inlierPoints2 = matchedPoints2(epipolarInliers, :);
    
    relPose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);
    relPose = relPose(1);
    relPose_cell{i} = relPose;

    camMatrix1 = cameraProjection(intrinsics, rigidtform3d);
    camMatrix2 = cameraProjection(intrinsics, pose2extr(relPose));

    % % Compute the 3-D points
    points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
    
    points3D_all = transformPointsForward(relPose, [points3D_all; points3D]);
end

% % R_inverted_cell = cell(1,size(imageFiles,1)-  1);
% % T_inverted_cell = cell(1,size(imageFiles,1)-  1);
% % T_inverted_cell{1, 1} = T_cell{1, 1};
% % T_temp = zeros(3, 1);




%% 
for i = 1:size(imageFiles,1)-2
    for j = i:size(imageFiles,1)-2
        if numel(matches{sequence(i),sequence(j)}) >15
            matchedPoints1 = matches{sequence(i),sequence(j)};
            matchedPoints2 = matches{sequence(j),sequence(i)};

            
            [E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, Confidence = 99.99);

            % Find epipolar inliers
            inlierPoints1 = matchedPoints1(epipolarInliers, :);
            inlierPoints2 = matchedPoints2(epipolarInliers, :);
            correspondences = [inlierPoints1'; inlierPoints2'];
            
            relPose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);
            camMatrix1 = cameraProjection(intrinsics, rigidtform3d);
            camMatrix2 = cameraProjection(intrinsics, pose2extr(relPose(1)));
            points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);

            points = transform_points(sequence(i),sequence(end),points3D,relPose_cell);

            points3D_all = [points3D_all; points];
    
        end
    end
    disp(i);
end
%%

% Extract x, y, and z coordinates from the array
points3D_all = points3D_all';
x = points3D_all(1, :);
y = points3D_all(2, :);
z = points3D_all(3, :);

% Plot the points in a 3D plot using scatter3
figure;
scatter3(x, y, z, 'filled');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Plot of Points');

[origin, sideLength, X_floor, Y_floor, Z_floor] = get_boxes(points3D_all');


%%
% 
% 
% 
% 
% Below here is code needed to sort the images
% features = cell(1,size(imageFiles,1));
% valid = cell(1,size(imageFiles,1));
% for i = 1:size(imageFiles,1)
%     I1 = im2gray(imread(imageFiles{i}));
%     harrisFeatures1 = detectHarrisFeatures(I1);
%     [features1,validCorners1] = extractFeatures(I1,harrisFeatures1);
%     features{i} = features1;
%     valid{i} = validCorners1;
% end
% %%
% tree = cell(1,size(imageFiles,1));
% matches = cell(size(imageFiles,1),size(imageFiles,1));
% for i = 1:size(imageFiles,1)
%     for j = i+1:size(imageFiles,1)
%         feature1 = features{i};
%         feature2 = features{j};
%         [indexPairs,matchMetric] = matchFeatures(feature1.Features,feature2.Features);
%         val1 = valid{i};
%         val2 = valid{j};
%         matchedPoints1 = val1.Location(indexPairs(:,1),:);
%         matchedPoints2 = val2.Location(indexPairs(:,2),:);
%         if length(matchedPoints1)>5 && length(matchedPoints2)>5
%             tree{i}(end+1) = j;
%             tree{j}(end+1) = i;
%             matches{i,j} = matchedPoints1;
%             matches{j,i} = matchedPoints2;
%         end
%     end
% end
%%