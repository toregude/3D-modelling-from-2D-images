% Specify the path to the subfolder containing the images
subfolderPath = '.\delivery_area_dslr_undistorted\delivery_area\images\dslr_images_undistorted\';

% Get a list of all files and folders in the subfolder
files = dir(fullfile(subfolderPath, '*.JPG'));  % Modify the file extension as needed

% Preallocate an array to store the image file names
imageFiles = cell(numel(files), 1);

% Store the file names in the array
for i = 1:numel(files)
    imageFiles{i} = fullfile(subfolderPath, files(i).name);
end


for i = 1:size(imageFiles,1)-1
    %%Match features from image i and image i+1
    I1 = im2gray(imread(imageFiles{i}));
    I2 = im2gray(imread(imageFiles{i}));

    [E, matchedPoints1_inliers,matchedPoints2_inliers] = match_features(I1, I2)
    %%Estimate E from matched features
    disp(E);

    %%Estimate R,T from E - set origin as camera center of first image

    %%Find in a magic way 3D points, must take acording to first camera
    %%frame

    %% Store 3D point
end

%%Display 3D point cloud and do some sort of best fit to this
