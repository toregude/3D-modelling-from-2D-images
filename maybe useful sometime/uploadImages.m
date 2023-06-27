% Display a dialog box to choose multiple image files
[fileNames, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp'}, 'Select image files', 'MultiSelect', 'on');
if isequal(fileNames, 0)
    disp('No image files selected.')
    return;
end

% Determine the number of selected images
numImages = numel(fileNames);

% Initialize a cell array to store the image data
imageDataArray = cell(1, numImages);

% Read and store the image data for each selected image
for i = 1:numImages
    imagePath = fullfile(path, fileNames{i});
    imageDataArray{i} = imread(imagePath);
end

% Display the uploaded images
figure;
for i = 1:numImages
    subplot(1, numImages, i);
    imshow(imageDataArray{i});
    title(['Image ', num2str(i)]);
end
