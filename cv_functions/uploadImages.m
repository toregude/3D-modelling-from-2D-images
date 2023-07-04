% appdesigner('GUI.mlapp');


% Open the GUI
app = GUI;


% Enable the button click event
DrawmodelButton.Enable = 'on';

% Wait for the button click event
uiwait(gcf);

% Continue with further code execution after the button is clicked
disp('Button clicked! Continuing with further code execution.');


X = load('imageData.mat');
images = X.imageDataArray;

%[origin, sideLength, X_floor, Y_floor, Z_floor] = get_boxes();
%app.origin = origin;
%app.sideLength = sideLength;
%app.X_floor = X_floor;
%app.Y_floor = Y_floor;
%app.Z_floor = Z_floor;
% % Display a dialog box to choose multiple image files
% [fileNames, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp'}, 'Select image files', 'MultiSelect', 'on');
% if isequal(fileNames, 0)
%     disp('No image files selected.')
%     return;
% end
% 
% % Determine the number of selected images
% numImages = numel(fileNames);
% 
% % Initialize a cell array to store the image data
% imageDataArray = cell(1, numImages);
% 
% % Read and store the image data for each selected image
% for i = 1:numImages
%     imagePath = fullfile(path, fileNames{i});
%     imageDataArray{i} = imread(imagePath);
% end
% 
% % Display the uploaded images
% figure;
% for i = 1:numImages
%     subplot(1, numImages, i);
%     imshow(imageDataArray{i});
%     title(['Image ', num2str(i)]);
% end
