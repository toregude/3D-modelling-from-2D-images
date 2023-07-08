%%
addpath('cv_functions');
addpath('GUI');
% Specify the path to the subfolder containing the images
subfolderPath = ".\test_data_kicker\images";
 
% Get a list of all files and folders in the subfolder
files = dir(fullfile(subfolderPath, '*.JPG'));  % Modify the file extension as needed

% Preallocate an array to store the image file names
imageFiles = cell(numel(files),1);

% Store the file names in the array. THEY ARE ACTUALLY SORTED!
for i = 1:numel(files)
    imageFiles{i} = fullfile(subfolderPath, files(i).name);
end

%Calibration matrix for the kicker
K_path = ".\test_data_kicker\parameters";
K = K_from_cameraparams(K_path);

%%Denen koden skal i utgangspunktet ikke trenges, men trengs på et eller
%%annet sykt vis, ikke rør
allData = readmatrix(".\test_data_kicker\parameters\images.txt");
cam_pos_unsorted = allData(:, 1:4);
[cam_pos_sorted,sort_index] = sortrows(cam_pos_unsorted);
imageFiles = imageFiles(sort_index);

imageSize = size(im2gray(imread(imageFiles{1})));
focalLength = [K(1,1) K(2,2)];
principalPoint = [K(1,3) K(2,3)];
intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);

%% Her er koden du trenger for å kjøre, alt over er bare lagt til for å få det til å kjøre
[features,valid] = find_features(imageFiles, intrinsics);
%% 
[tree, matches] = find_match_tree(features,valid, imageFiles);
sequence = find_completed_sequence(tree, 1);

disp(sequence);
%%
scale_factor = find_scale_factor(cam_pos_sorted, sequence);
%%
num_imageFiles = size(imageFiles,1);
[relPose_cell, points3D_all] = get_relPosecell_and_3D_points(matches, sequence, intrinsics,num_imageFiles,K,scale_factor);

%% 
points3D_all = get_all_3D_points(points3D_all, num_imageFiles, matches, sequence, relPose_cell, intrinsics);
%%
get_global_coordinates_list(points3D_all);
