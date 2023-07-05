% Specify the path to the subfolder containing the images
subfolderPath = "C:\Users\Tore Gude\OneDrive - NTNU\Termin 8 - Tyskland\Computer Vision\Prosjekt\Computer-Vision-gutta\test_data_kicker\images";

% Get a list of all files and folders in the subfolder
files = dir(fullfile(subfolderPath, '*.JPG'));  % Modify the file extension as needed

% Preallocate an array to store the image file names
imageFiles = cell(numel(files), 1);

% Store the file names in the array. THEY ARE ACTUALLY SORTED!
for i = 1:numel(files)
    imageFiles{i} = fullfile(subfolderPath, files(i).name);
end

%Calibration matrix for the kicker
K_path = "C:\Users\Tore Gude\OneDrive - NTNU\Termin 8 - Tyskland\Computer Vision\Prosjekt\Computer-Vision-gutta\test_data_kicker\parameters";
[K] = K_from_cameraparams(K_path);

allData = readmatrix("C:\Users\Tore Gude\OneDrive - NTNU\Termin 8 - Tyskland\Computer Vision\Prosjekt\Computer-Vision-gutta\test_data_kicker\parameters\images.txt");
cam_pos_unsorted = allData(:, 1:4);
[cam_pos_sorted,sort_index] = sortrows(cam_pos_unsorted);
imageFiles = imageFiles(sort_index);

all_points_3D = [];
all_color = [];
image = im2gray(imread(imageFiles{1}));
%IKKE SJEKKA KODE
imageSize = size(image);
focalLength = [K(1,1) K(2,2)];
principalPoint = [K(1,3) K(2,3)];
intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
for i = 1: size(imageFiles,1)-1 
    I1 = im2gray(imread(imageFiles{i}));
    I2 = im2gray(imread(imageFiles{i+1}));

    C1 = cam_pos_sorted(i,2:4);
    C2 = cam_pos_sorted(i+1,2:4);

    harrisFeatures1 = detectHarrisFeatures(I1);
    harrisFeatures2 = detectHarrisFeatures(I2);
    [features1,validCorners1] = extractFeatures(I1,harrisFeatures1);
    [features2,validCorners2] = extractFeatures(I2,harrisFeatures2);
    
    [indexPairs,matchMetric] = matchFeatures(features1,features2);

    matchedPoints1 = validCorners1.Location(indexPairs(:,1),:);
    matchedPoints2 = validCorners2.Location(indexPairs(:,2),:);
    disp(i);

    
    if length(matchedPoints1)<5 || length(matchedPoints2)<5
            disp("skippede");
            disp(size(matchedPoints1));
            continue;
    end

    [E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, Confidence = 99.99);

    
end