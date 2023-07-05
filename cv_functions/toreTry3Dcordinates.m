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

features = cell(1,size(imageFiles,1));
valid = cell(1,size(imageFiles,1));

%%
for i = 1:size(imageFiles,1)
    I1 = im2gray(imread(imageFiles{i}));
    harrisFeatures1 = detectHarrisFeatures(I1);
    [features1,validCorners1] = extractFeatures(I1,harrisFeatures1);
    features{i} = features1;
    valid{i} = validCorners1;
end
%%
tree = cell(1,size(imageFiles,1));
matches = cell(size(imageFiles,1),size(imageFiles,1));
for i = 1:size(imageFiles,1)
    for j = i+1:size(imageFiles,1)
        feature1 = features{i};
        feature2 = features{j};
        [indexPairs,matchMetric] = matchFeatures(feature1.Features,feature2.Features);
        val1 = valid{i};
        val2 = valid{j};
        matchedPoints1 = val1.Location(indexPairs(:,1),:);
        matchedPoints2 = val2.Location(indexPairs(:,2),:);
        if length(matchedPoints1)>5 && length(matchedPoints2)>5
            tree{i}(end+1) = j;
            tree{j}(end+1) = i;
            matches{i,j} = matchedPoints1;
            matches{j,i} = matchedPoints2;
        end
    end
end
%%
sequence = findCompletedSequence(tree, 1);
disp(sequence);
imageFiles = imageFiles(sequence);
cam_pos_sorted = cam_pos_sorted(sequence);

Es = cell(1,size(imageFiles,1)-1);
inlierPoints1 = cell(1,size(imageFiles,1)-1);
inlierPoints2 = cell(1,size(imageFiles,1)-1);
for i = 1:size(imageFiles,1)-2 % Usikker på hvorfor det må være -2 og ikke -1, virker som at siste bildet ikke blir sortert
    [E, epipolarInliers] = estimateEssentialMatrix(matches{sequence(i),sequence(i+1)}, matches{sequence(i+1),sequence(i)}, intrinsics, Confidence = 0.99);
    Es{i} = E;
    inlierPoints1{i} = matches{sequence(i),sequence(i+1)}(epipolarInliers, :);
    inlierPoints2{i} = matches{sequence(i+1),sequence(i)}(epipolarInliers, :);
end