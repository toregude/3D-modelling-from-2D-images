%%
addpath('cv_functions');

% Open the GUI
app = GUI;


%%
% Wait for the button click event
while ~app.waitforGUI
    pause(0.1);
end
app.mywaitbar = waitbar(0,'Please wait...');

%%
% Preallocate an array to store the image file names
image_files = app.imageDataArray;

%Calibration matrix
intrinsics = intrinsics_from_cameraparams(app.camerastxt, image_files);

waitbar(1/7,app.mywaitbar,'Finding features');

%% Her er koden du trenger for å kjøre, alt over er bare lagt til for å få det til å kjøre
[features, valid_points] = find_features(image_files,intrinsics);
waitbar(2/7,app.mywaitbar,'Matching features');

%% 
matches = find_match_graph(features, valid_points, image_files);

%%
scale_factor = find_scale_factor(app.imagestxt, matches);
waitbar(3/5,app.mywaitbar, 'Creating 3D points');

%%
[relative_pose_cell] = get_relative_pose_cell(matches, intrinsics, scale_factor);

%% 
points_3D_array = get_points_3D_array(matches, intrinsics, relative_pose_cell);
waitbar(4/5,app.mywaitbar,'Clustering');

%%
[app.origin, app.sideLengths, app.floor_walls] = create_model_from_points(points_3D_array);
waitbar(5/5);

app.DrawmodelButton.Visible = "on";
close(app.mywaitbar);