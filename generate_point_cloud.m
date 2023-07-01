%EVERYTHING HERE IS IMPLEMENTED WITH RESPECT TO THE KICKER PICTURES!
%Lot of inspiration gathered from here: https://se.mathworks.com/help/vision/ug/structure-from-motion-from-two-views.html

addpath('cv_functions');
addpath('colmap');

% Specify the path to the subfolder containing the images
subfolderPath = '.\test_data_kicker\images\';

% Get a list of all files and folders in the subfolder
files = dir(fullfile(subfolderPath, '*.JPG'));  % Modify the file extension as needed

% Preallocate an array to store the image file names
imageFiles = cell(numel(files), 1);

% Store the file names in the array
for i = 1:numel(files)
    imageFiles{i} = fullfile(subfolderPath, files(i).name);
end

%This is just for testing purposes:
I1 = im2gray(imread('.\test_data_kicker\images\DSC_6502.JPG')); %pic 13
I2 = im2gray(imread('.\test_data_kicker\images\DSC_6503.JPG')); %pic 14

%Calibration matrix for the kicker
K = [3410.34 0 3121.33;
    0 3409.98 2067.07;
    0 0 1];

% 13 -0.80045 -3.89799 -0.3211 0 dslr_images_undistorted/DSC_6502.JPG 
% 14 0.06759 -4.61025 -0.31782 0 dslr_images_undistorted/DSC_6503.JPG
C1 = [-0.80045 -3.89799 -0.3211]';
C2 = [0.06759 -4.61025 -0.31782]';

%Matlab functions we should use:
% detectHarrisFeatures
% extractFeatures
% matchFeatures
% estgeotform3d
% cameraIntrinsics
% triangulate

for i = 1:size(imageFiles,1)-1 %-1 since we iterate over both i and i+1
    %Get the grayscale images i and i+1.
    %The code here is really how we should do it! But do we need to sort the pictures first? After similarity?
    % I1 = im2gray(imread(imageFiles{i}));
    % I2 = im2gray(imread(imageFiles{i+1}));

    %Generate camera intrinsics
    focalLength = [K(1,1) K(2,2)];
    principalPoint = [K(1,3) K(2,3)];
    imageSize1 = size(I1);
    imageSize2 = size(I2);
    if imageSize1 ~= imageSize2
        "Conflicting image sizes! Fix this!"
    else
        imageSize = imageSize1;
    end
    intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
    
    %Undistort the pictures
    I1 = undistortImage(I1, intrinsics);
    I2 = undistortImage(I2, intrinsics);

    harrisFeatures1 = detectHarrisFeatures(I1);
    harrisFeatures2 = detectHarrisFeatures(I2);
    [features1,validCorners1] = extractFeatures(I1,harrisFeatures1);
    [features2,validCorners2] = extractFeatures(I2,harrisFeatures2);
    
    [indexPairs,matchMetric] = matchFeatures(features1,features2);

    matchedPoints1 = validCorners1.Location(indexPairs(:,1),:);
    matchedPoints2 = validCorners2.Location(indexPairs(:,2),:);

    if (length(matchedPoints1) < 5) || (length(matchedPoints2) < 5)
        continue;
    end
    
    %Visualize correspondences
    figure
    showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
    title("Tracked Features");

    % Estimate the fundamental matrix
    [E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, Confidence = 99.99);

    % Find epipolar inliers
    inlierPoints1 = matchedPoints1(epipolarInliers, :);
    inlierPoints2 = matchedPoints2(epipolarInliers, :);
    
    % Display inlier matches
    figure
    showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
    title('Epipolar Inliers');

    %calculates the pose of a calibrated camera relative to its previous pose
    relPose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);

    "Calculated translation:"
    T = relPose.Translation

    "Real translation"
    C2-C1

    % % Detect dense feature points. Use an ROI to exclude points close to the image edges.
    % border = 30;
    % roi = [border, border, size(I1, 2)- 2*border, size(I1, 1)- 2*border];
    % imagePoints1 = detectHarrisFeatures(im2gray(I1), ROI = roi, MinQuality = 0.001);
    % 
    % % Create the point tracker
    % tracker = vision.PointTracker();
    % 
    % % Initialize the point tracker
    % imagePoints1 = imagePoints1.Location;
    % initialize(tracker, imagePoints1, I1);
    % 
    % % Track the points
    % [imagePoints2, validIdx] = step(tracker, I2);
    % matchedPoints1 = imagePoints1(validIdx, :);
    % matchedPoints2 = imagePoints2(validIdx, :);
    % 
    % % Compute the camera matrices for each position of the camera
    % % The first camera is at the origin looking along the Z-axis. Thus, its
    % % transformation is identity.
    % camMatrix1 = cameraProjection(intrinsics, rigidtform3d);
    % camMatrix2 = cameraProjection(intrinsics, pose2extr(relPose));
    % 
    % % Compute the 3-D points
    % points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
    % 
    % % Get the color of each reconstructed point
    % %THIS IS BAD CODE! THIS IS REDUNDANT, AND SHOULD BE DONE IN ANOTHER WAY.
    % I1 = imread('.\test_data_kicker\images\DSC_6489.JPG');
    % I2 = imread('.\test_data_kicker\images\DSC_6502.JPG');
    % % I1 = imread(imageFiles{i});
    % % I2 = imread(imageFiles{i+1});
    % 
    % numPixels = size(I1, 1) * size(I1, 2);
    % allColors = reshape(I1, [numPixels, 3]);
    % colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(matchedPoints1(:,2)), ...
    %     round(matchedPoints1(:, 1)));
    % color = allColors(colorIdx, :);
    % 
    % % Create the point cloud
    % ptCloud = pointCloud(points3D, 'Color', color);
    % 
    % % Visualize the camera locations and orientations
    % cameraSize = 0.3;
    % figure
    % plotCamera(Size=cameraSize, Color='r', Label='1', Opacity=0);
    % hold on
    % grid on
    % plotCamera(AbsolutePose=relPose, Size=cameraSize, ...
    %     Color='b', Label='2', Opacity=0);
    % 
    % % Visualize the point cloud
    % pcshow(ptCloud, VerticalAxis='y', VerticalAxisDir='down', MarkerSize=45);
    % 
    % % Rotate and zoom the plot
    % camorbit(0, -30);
    % camzoom(1.5);
    % 
    % % Label the axes
    % xlabel('x-axis');
    % ylabel('y-axis');
    % zlabel('z-axis')
    % 
    % title('Up to Scale Reconstruction of the Scene');
    % 
    % % Determine the scale factor
    % scaleFactor = 10;
    % 
    % % Scale the point cloud
    % ptCloud = pointCloud(points3D * scaleFactor, Color=color);
    % relPose.Translation = relPose.Translation * scaleFactor;
    % 
    % % Visualize the point cloud in centimeters
    % cameraSize = 2; 
    % figure
    % plotCamera(Size=cameraSize, Color='r', Label='1', Opacity=0);
    % hold on
    % grid on
    % plotCamera(AbsolutePose=relPose, Size=cameraSize, ...
    %     Color='b', Label='2', Opacity=0);
    % 
    % %HERE WE SHOULD MERGE THE NEW POINT CLOUD WITH THE OLD!
    % 
    % % Visualize the point cloud
    % pcshow(ptCloud, VerticalAxis='y', VerticalAxisDir='down', MarkerSize=45);
    % camorbit(0, -30);
    % camzoom(1.5);
    % 
    % % Label the axes
    % xlabel('x-axis (cm)');
    % ylabel('y-axis (cm)');
    % zlabel('z-axis (cm)')
    % title('Metric Reconstruction of the Scene');

    %Add a break just for debugging so that the loop does not go too far    
    break;
end
