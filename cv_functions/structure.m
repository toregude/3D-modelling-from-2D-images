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

%NOT SURE WHERE THIS FITS IN:
% cameraParams = cameraParameters;
% K = [3408.59 0 3117.24; 0 3408.87 2064.07; 0 0 1];
%   CAMERA_ID, MODEL, WIDTH, HEIGHT, PARAMS[]
%Delivery area:0 PINHOLE 6208 4135 3408.59 3408.87 3117.24 2064.07.
%Kicker: 0 PINHOLE 6211 4137 3410.34 3409.98 3121.33 2067.07
%SO THE LAST FOUR NUMBERS ARE THE CAMERA PARAMS? ARE THEY STRUCTURED IN THE MATRIX LIKE THE K DEFINED ABOVE? 

for i = 1:size(imageFiles,1)-1 %-1 since we iterate over both i and i+1
    %Get the grayscale images i and i+1
    I1 = im2gray(imread(imageFiles{i}));
    I2 = im2gray(imread(imageFiles{i+1}));
    
    %Get the matched features and E for each pair. Features are run through RANSAC before computing E.
    [E, matchedPoints1_inliers,matchedPoints2_inliers] = match_features(I1, I2)
    %Estimate E from matched features
    disp(E);

    %Estimate R,T from E - set origin as camera center of first image

    %Find in a magic way 3D points, must take acording to first camera
    %frame

    % Store 3D point
end

%%Display 3D point cloud and do some sort of best fit to this