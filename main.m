addpath('cv_functions');
addpath('GUI_functions')

%%
% Open the GUI
app = GUI;

%%
% Wait for the button click event
while ~app.wait_for_GUI
    pause(0.1);
end
app.my_wait_bar = waitbar(0,'Please wait...');
figure(app.my_wait_bar);

%%
% Preallocate an array to store the image file names, and then load the images
waitbar(1/9, app.my_wait_bar, 'Loading images');
image_files = app.image_data_array;

%%
% Get camera intrinsics from text file
waitbar(2/9, app.my_wait_bar, 'Loading camera intrinsics');
camera_intrinsics = get_camera_intrinsics(app.cameras_txt, image_files);

%%
% Create two cells, one for the features of all images, another for the valid points of all images
waitbar(3/9, app.my_wait_bar, 'Finding features');
[features_cell, valid_points_cell] = get_features_and_valid_points_cell(image_files, camera_intrinsics);

%% 
% Create a matrix containing the matched features of all pictures
waitbar(4/9,app.my_wait_bar,'Matching features');
matches_matrix = get_matches_matrix(features_cell, valid_points_cell, image_files);

%%
% Utilize the absolute camera positions to calculate the scale factors of the relative translations
waitbar(5/9,app.my_wait_bar,'Calculating scale factors');
scaling_factor_matrix = get_scaling_factor_matrix(app.images_txt, matches_matrix);

%%
% Calculate the relative poses between all pictures, from one frame to the next one in the image sequence
waitbar(6/9,app.my_wait_bar,'Calculating relative poses');
[relative_pose_cell] = get_relative_pose_cell(matches_matrix, camera_intrinsics, scaling_factor_matrix);

%% 
% Triangulate 3D points using the matched points and relative poses between images
waitbar(7/9,app.my_wait_bar, 'Triangulating 3D points');
points_3D_array = get_points_3D_array(matches_matrix, camera_intrinsics, relative_pose_cell);

%%
% Create the actual 3D model
waitbar(8/9,app.my_wait_bar,'Creating 3D model');
[app.origin, app.side_lengths, app.floor_walls] = create_3D_model(points_3D_array);

%%
waitbar(9/9);
app.DrawmodelButton.Visible = "on";

figure(app.UIFigure);
close(app.my_wait_bar);