
app = GUI;
waitfor(app.UIFigure);


X = load('imageData.mat');
images = X.imageDataArray;

allData = readmatrix("images.txt");
cam_pos_unsorted = allData(:, 1:4);
[cam_pos_sorted,sort_index] = sortrows(cam_pos_unsorted);
images = images(sort_index);

