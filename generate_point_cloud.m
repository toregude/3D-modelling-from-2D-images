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
    
    %Undistort the pictures
    % I1 = undistortImage(I1, intrinsics);
    % I2 = undistortImage(I2, intrinsics);

    harrisFeatures1 = detectHarrisFeatures(im2gray(I1));
    harrisFeatures2 = detectHarrisFeatures(im2gray(I2));
    [features1,validCorners1] = extractFeatures(im2gray(I1),harrisFeatures1);
    [features2,validCorners2] = extractFeatures(im2gray(I2),harrisFeatures2);
    
    [indexPairs,matchMetric] = matchFeatures(features1,features2);

    matchedPoints1 = validCorners1.Location(indexPairs(:,1),:);
    matchedPoints2 = validCorners2.Location(indexPairs(:,2),:);

    if (length(matchedPoints1) < 5) || (length(matchedPoints2) < 5)
        continue;
    end
    
    %Visualize correspondences
    % figure
    % showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
    % title("Tracked Features");

    % Estimate the fundamental matrix
    [E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, Confidence = 99.99);

    % Find epipolar inliers
    inlierPoints1 = matchedPoints1(epipolarInliers, :);
    inlierPoints2 = matchedPoints2(epipolarInliers, :);
    
    % "Check 1"

    % Display inlier matches
    % figure
    % showMatchedFeatures(I1, I2, inlierPoints1, inlierPoints2);
    % title('Epipolar Inliers');

    correspondences = [inlierPoints1'; inlierPoints2'];

    [T1, T2, R1, R2] = TR_from_E(E);
    % [T, R, lambda, P] = reconstruction(T1, T2, R1, R2, C1, C2, correspondences, K); %DENNE HER ER MYE VERRE EN GUSTAV SIN! HVORFOR?
    [T,R, lambda, P] = rekonstruktion(T1,T2,R1,R2,C1, correspondences, K); %DENNE ER GUSTAV SIN
    % 
    % T_exact = C2-C1;
    % 
    % "How does the exact T compare to the computed T???"
    % T-T_exact
    % T1 - T_exact
    % T2 - T_exact
    
    %BRUK RELPOSE!! 
    %calculates the pose of a calibrated camera relative to its previous pose
    % relPose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);
    
    % "Check 2"
    % "Calculated translation:"
    % T_estrel = relPose.Translation;

    % "Forskjell translasjon"
    % norm(T+T_estrel')
    % 
    % "Forskjell rotasjon"
    % norm(R-relPose.Rotation,"fro")

    % 
    % "Real translation"
    % C2-C1
    % 
    % % % Detect dense feature points. Use an ROI to exclude points close to the image edges.
    % border = 30;
    % roi = [border, border, size(I1, 2)- 2*border, size(I1, 1)- 2*border];
    % imagePoints1 = detectHarrisFeatures(im2gray(I1), ROI = roi, MinQuality = 0.01);
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
    
    % "Check 3"

    % Compute the camera matrices for each position of the camera
    % The first camera is at the origin looking along the Z-axis. Thus, its
    % transformation is identity.
    % pose = pose2extr(relPose);
    % 
    % camMatrix1 = cameraProjection(intrinsics, rigidtform3d);
    % % camMatrix2 = cameraProjection(intrinsics, pose2extr(relPose));
    % camMatrix2 = cameraProjection(intrinsics, pose);
    % 
    % % Compute the 3-D points
    % % points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
    % points3D = triangulate(inlierPoints1, inlierPoints2, camMatrix1, camMatrix2);

    % all_points_3D = [all_points_3D; points3D];
    all_points_3D = [all_points_3D; P'];

    %GJØR ALT FREM TIL HER FOR ALLE BILDEPAR! HVOR DU SLÅR SAMMEN ALLE POINTS3D, OG DERETTER LAGER PUNKTSKYOBJECT.

    % scatter3(points3D(:,1),points3D(:,2),points3D(:,3));

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
    % all_color = [all_color; color];

    numPixels = size(I1, 1) * size(I1, 2);
    allColors = reshape(I1, [numPixels, 3]);
    colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(inlierPoints1(:,2)), ...
        round(inlierPoints1(:, 1)));
    color = allColors(colorIdx, :);

    all_color = [all_color; color];
    % 
    
    % 
    % % %Add a break just for debugging so that the loop does not go too far    
    % break;
    "Iterasjon nummer"
    i

    if i >= 10
        break;
    end
end

figure
scatter3(all_points_3D(:,1),all_points_3D(:,2),all_points_3D(:,3))

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
