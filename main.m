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
% Preallocate an array to store the image file names
imageFiles = app.imageDataArray;

%Calibration matrix for the kicker
intrinsics = intrinsics_from_cameraparams(camerastxt, imageFiles);

%%Denen koden skal i utgangspunktet ikke trenges, men trengs på et eller
%%annet sykt vis, ikke rør
% [cam_pos_sorted,sort_index] = sortrows(app.imagestxt);
% imageFiles = imageFiles(sort_index);


waitbar(1/7,app.mywaitbar,'Finding features');

%% Her er koden du trenger for å kjøre, alt over er bare lagt til for å få det til å kjøre
[features, valid_points] = find_features(imageFiles,intrinsics);
waitbar(2/7,app.mywaitbar,'Matching features');
%% 
[G, matches] = find_match_graph(features, valid_points, imageFiles);

%%
scale_factor = find_scale_factor(app.imagestxt);
waitbar(3/5,app.mywaitbar, 'Creating 3D points');
    %%

num_imageFiles = size(imageFiles,1);
[relPose_cell, points3D_all] = get_relPosecell_and_3D_points(matches, sequence, intrinsics,num_imageFiles,K,scale_factor);

%% 
points3D_all = get_all_3D_points(points3D_all, num_imageFiles, matches, sequence, relPose_cell, intrinsics);
waitbar(4/5,app.mywaitbar,'Clustering');
%%
[app.origin, app.sideLengths] = get_global_coordinates_list(points3D_all);
waitbar(5/5);
app.DrawmodelButton.Visible = "on";
close(app.mywaitbar);
