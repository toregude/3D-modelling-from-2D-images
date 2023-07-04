%EVERYTHING HERE IS IMPLEMENTED WITH RESPECT TO THE KICKER PICTURES!
%Lot of inspiration gathered from here: https://se.mathworks.com/help/vision/ug/structure-from-motion-from-two-views.html
clear global;

addpath('cv_functions');
addpath('colmap');

% Specify the path to the subfolder containing the images
subfolderPath = '.\test_data_kicker\images\';

% Get a list of all files and folders in the subfolder
files = dir(fullfile(subfolderPath, '*.JPG'));  % Modify the file extension as needed

% Preallocate an array to store the image file names
imageFiles = cell(numel(files), 1);

% Store the file names in the array. THEY ARE ACTUALLY SORTED!
for i = 1:numel(files)
    imageFiles{i} = fullfile(subfolderPath, files(i).name);
end

%Calibration matrix for the kicker
K_path = '.\test_data_kicker\parameters\';
[K] = K_from_cameraparams(K_path);

allData = readmatrix('.\test_data_kicker\parameters\images.txt');
cam_pos_unsorted = allData(:, 1:4);
[cam_pos_sorted,sort_index] = sortrows(cam_pos_unsorted);

%Matlab functions we should use:
% detectHarrisFeatures
% extractFeatures
% matchFeatures
% estgeotform3d
% cameraIntrinsics
% triangulate

all_points_3D = [];
all_color = [];
for i = 1:size(imageFiles,1)-1 %-1 since we iterate over both i and i+1    
    %THE IMAGES ARE NATURALLY SORTED IN THE SAME WAY AS 
    I1 = imread(imageFiles{i});
    I2 = imread(imageFiles{i+1});

    C1 = cam_pos_sorted(i,2:4);
    C2 = cam_pos_sorted(i+1,2:4);

    %Generate camera intrinsics
    focalLength = [K(1,1) K(2,2)];
    principalPoint = [K(1,3) K(2,3)];
    imageSize1 = size(I1);
    imageSize2 = size(I2);
    if imageSize1 ~= imageSize2
        "Conflicting image sizes! Fix this!"
    else
        imageSize = imageSize1(:,1:2);
    end
    intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
   
    
    % Convert the images to grayscale
    I1 = rgb2gray(I1);
    I2 = rgb2gray(I2);
    
    % Detect feature points
    points1 = detectSURFFeatures(I1);
    points2 = detectSURFFeatures(I2);
    
    % Extract feature descriptors
    [features1, validPoints1] = extractFeatures(I1, points1);
    [features2, validPoints2] = extractFeatures(I2, points2);
    
    % Match features between images
    indexPairs = matchFeatures(features1, features2);
    matchedPoints1 = validPoints1(indexPairs(:, 1), :);
    matchedPoints2 = validPoints2(indexPairs(:, 2), :);
    
    % Estimate the essential matrix
    [E, ~] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics);
    
    % Extract the inlier point correspondences
    inlierPoints1 = matchedPoints1;
    inlierPoints2 = matchedPoints2;

    relPose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);
    P1 = cameraProjection(intrinsics, rigidtform3d);
    P2 = cameraProjection(intrinsics, pose2extr(relPose));
    
    % Camera projection matrices
    % P1 = cameraMatrix(cameraParams, eye(3), [0 0 0]);
    % P2 = cameraMatrix(cameraParams, cameraParams.RotationOfCamera2, cameraParams.TranslationOfCamera2);
    
    % Reconstruct 3D points
    [worldPoints, ~] = triangulate(inlierPoints1, inlierPoints2, P1, P2);
    all_points_3D = [all_points_3D;worldPoints];

end

figure;
scatter3(all_points_3D(:, 1), all_points_3D(:, 2), all_points_3D(:, 3), 'filled');
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Point Cloud');

% figure
% scatter3(all_points_3D(:,1),all_points_3D(:,2),all_points_3D(:,3))

% Create the point cloud
% ptCloud = pointCloud(points3D, 'Color', color);
% "Lage pointcloud"
% ptCloud = pointCloud(all_points_3D, 'Color', all_color);

% Visualize the camera locations and orientations
% cameraSize = 0.3;
% figure
% plotCamera(Size=cameraSize, Color='r', Label='1', Opacity=0);
% hold on
% grid on
% plotCamera(AbsolutePose=relPose, Size=cameraSize, ...
%     Color='b', Label='2', Opacity=0);


% Visualize the point cloud
% "Visualisere pointcloud"
% pcshow(ptCloud, VerticalAxis='y', VerticalAxisDir='down', MarkerSize=45);
% 
% % Rotate and zoom the plot
% % camorbit(0, -30);
% % camzoom(1.5);
% 
% % Label the axes
% xlabel('x-axis');
% ylabel('y-axis');
% zlabel('z-axis')
% 
% title('Up to Scale Reconstruction of the Scene');

% Determine the scale factor
% scaleFactor = 10;
% scaleFactor = 1;

% Scale the point cloud
% ptCloud = pointCloud(points3D * scaleFactor, Color=color);
% relPose.Translation = relPose.Translation * scaleFactor;

% Visualize the point cloud in centimeters
% cameraSize = 2; 
% figure
% plotCamera(Size=cameraSize, Color='r', Label='1', Opacity=0);
% hold on
% grid on
% plotCamera(AbsolutePose=relPose, Size=cameraSize, ...
%     Color='b', Label='2', Opacity=0);

%HERE WE SHOULD MERGE THE NEW POINT CLOUD WITH THE OLD!

% Visualize the point cloud
% pcshow(ptCloud, VerticalAxis='y', VerticalAxisDir='down', MarkerSize=45);
% camorbit(0, -30);
% camzoom(1.5);

% Label the axes
% xlabel('x-axis (cm)');
% ylabel('y-axis (cm)');
% zlabel('z-axis (cm)')
% title('Metric Reconstruction of the Scene');
