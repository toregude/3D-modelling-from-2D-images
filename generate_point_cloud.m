%EVERYTHING HERE IS IMPLEMENTED WITH RESPECT TO THE KICKER PICTURES!
%Lot of inspiration gathered from here: https://se.mathworks.com/help/vision/ug/structure-from-motion-from-two-views.html

addpath('cv_functions');
addpath('colmap');

% Specify the path to the subfolder containing the images
subfolderPath = '.\kicker_dslr_undistorted\kicker\images\dslr_images_undistorted\';

% Get a list of all files and folders in the subfolder
files = dir(fullfile(subfolderPath, '*.JPG'));  % Modify the file extension as needed

% Preallocate an array to store the image file names
imageFiles = cell(numel(files), 1);

% Store the file names in the array
for i = 1:numel(files)
    imageFiles{i} = fullfile(subfolderPath, files(i).name);
end

%Calibration matrix for the kicker
K = [3410.34 0 3121.33;
    0 3409.98 2067.07;
    0 0 1];

%Matlab functions we should use:
% detectHarrisFeatures
% extractFeatures
% matchFeatures
% estgeotform3d
% cameraIntrinsics

for i = 1:size(imageFiles,1)-1 %-1 since we iterate over both i and i+1
    %Get the grayscale images i and i+1.
    %The code here is really how we should do it! But do we need to sort the pictures first? After similarity?
%     I1 = im2gray(imread(imageFiles{i}));
%     I2 = im2gray(imread(imageFiles{i+1}));

    %This is just for testing purposes:
    I1 = im2gray(imread('.\kicker_dslr_undistorted\kicker\images\dslr_images_undistorted\DSC_6489.JPG'));
    I2 = im2gray(imread('.\kicker_dslr_undistorted\kicker\images\dslr_images_undistorted\DSC_6502.JPG'));

    %Generate camera intrinsics
    focalLength = [3410.34 3409.98];
    principalPoint = [3121.33 2067.07];
    imageSize = size(I1);
    intrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize);
    
    %Estimating K, just to see if it is feasible
    k = 1.25; %Chosen in the interval [0.5 2] is normal
    K_estimated = estimate_K(imageSize, k);
    focalLength_estimated = [K_estimated(1,1) K_estimated(1,1)];
    principalPoint_estimated = [K_estimated(1,3) K_estimated(2,3)];
    intrinsics_estimated = cameraIntrinsics(focalLength_estimated, principalPoint_estimated, imageSize);
    
    %Show the two pictures, trying to undistort
    I1_undistort = undistortImage(I1, intrinsics);
    I2_undistort = undistortImage(I2, intrinsics);
%     figure
%     imshowpair(I1_undistort, I2_undistort, "montage");
%     title("Undistorted Images, real K");

    I1_undistort_estimated = undistortImage(I1, intrinsics_estimated);
    I2_undistort_estimated = undistortImage(I2, intrinsics_estimated);
%     figure
%     imshowpair(I1_undistort_estimated, I2_undistort_estimated, "montage");
%     title("Undistorted Images, estimated K");

    %ONLY CHOOSE ONE OF THE FOLLOWING K!!!
    %Utilize the real K in the rest of the script.
    I1 = I1_undistort;
    I2 = I2_undistort;
    intrinsics = intrinsics;
    
    %Utilize the estimated K in the rest of the script. Hopefully the results are okay.
%     I1 = I1_undistort_estimated;
%     I2 = I2_undistort_estimated;
%     intrinsics = intrinsics_estimated;

    %Detect feature points of first picture
    imagePoints1 = detectHarrisFeatures(I1);
    
    %Visualize detected points of first pic
%     figure
%     imshow(I1, InitialMagnification = 50);
%     title("150 Strongest Corners from the First Image");
%     hold on
%     plot(selectStrongest(imagePoints1, 150));
    
    %Create the point tracker
    tracker = vision.PointTracker(MaxBidirectionalError=1, NumPyramidLevels=5);
    
    %Initialize the point tracker
    imagePoints1 = imagePoints1.Location;
    initialize(tracker, imagePoints1, I1);

    %Track the points
    [imagePoints2, validIdx] = step(tracker, I2);
    matchedPoints1 = imagePoints1(validIdx, :);
    matchedPoints2 = imagePoints2(validIdx, :);

    %Visualize correspondences
    figure
    showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
    title("Tracked Features");

    

    % Estimate the fundamental matrix
    [E, epipolarInliers] = estimateEssentialMatrix(...
    matchedPoints1, matchedPoints2, intrinsics, Confidence = 99.99);

    % Find epipolar inliers
    inlierPoints1 = matchedPoints1(epipolarInliers, :);
    inlierPoints2 = matchedPoints2(epipolarInliers, :);
    
    % Display inlier matches
    figure
    showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
    title('Epipolar Inliers');

    relPose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);

    % Detect dense feature points. Use an ROI to exclude points close to the
    % image edges.
    border = 30;
    roi = [border, border, size(I1, 2)- 2*border, size(I1, 1)- 2*border];
    imagePoints1 = detectMinEigenFeatures(im2gray(I1), ROI = roi, ...
        MinQuality = 0.001);
    
    % Create the point tracker
    tracker = vision.PointTracker();
    
    % Initialize the point tracker
    imagePoints1 = imagePoints1.Location;
    initialize(tracker, imagePoints1, I1);
    
    % Track the points
    [imagePoints2, validIdx] = step(tracker, I2);
    matchedPoints1 = imagePoints1(validIdx, :);
    matchedPoints2 = imagePoints2(validIdx, :);
    
    % Compute the camera matrices for each position of the camera
    % The first camera is at the origin looking along the Z-axis. Thus, its
    % transformation is identity.
    camMatrix1 = cameraProjection(intrinsics, rigidtform3d);
    camMatrix2 = cameraProjection(intrinsics, pose2extr(relPose));
    
    % Compute the 3-D points
    points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
    
    % Get the color of each reconstructed point
    numPixels = size(I1, 1) * size(I1, 2);
    allColors = reshape(I1, [numPixels, 3]);
    colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(matchedPoints1(:,2)), ...
        round(matchedPoints1(:, 1)));
    color = allColors(colorIdx, :);
    
    % Create the point cloud
    ptCloud = pointCloud(points3D, 'Color', color);

    % Visualize the camera locations and orientations
    cameraSize = 0.3;
    figure
    plotCamera(Size=cameraSize, Color='r', Label='1', Opacity=0);
    hold on
    grid on
    plotCamera(AbsolutePose=relPose, Size=cameraSize, ...
        Color='b', Label='2', Opacity=0);
    
    % Visualize the point cloud
    pcshow(ptCloud, VerticalAxis='y', VerticalAxisDir='down', MarkerSize=45);
    
    % Rotate and zoom the plot
    camorbit(0, -30);
    camzoom(1.5);
    
    % Label the axes
    xlabel('x-axis');
    ylabel('y-axis');
    zlabel('z-axis')
    
    title('Up to Scale Reconstruction of the Scene');


    break
end

%%Display 3D point cloud and do some sort of best fit to this

% [F, epipolarInliers] = estimateFundamentalMatrix(...
% matchedPoints1, matchedPoints2, Confidence = 99.99);
% 
% %Trying to escape the fact that we do not know how to calibrate our camera?
% [U, S, V] = svd(F);
% s = (S(1,1) + S(2,2))/2;
% S = [s 0 0; 0 s 0; 0 0 0];
% E = U*S*V';
