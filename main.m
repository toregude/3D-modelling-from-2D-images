%%
addpath('cv_functions');

% Open the GUI
app = GUI;


%%
% Wait for the button click event
while ~app.waitforGUI
    pause(0.1);
end

% Preallocate an array to store the image file names
imageFiles = app.imageDataArray;

%Calibration matrix for the kicker
K = K_from_cameraparams(app.camerastxt);

%%Denen koden skal i utgangspunktet ikke trenges, men trengs på et eller
%%annet sykt vis, ikke rør
% [cam_pos_sorted,sort_index] = sortrows(app.imagestxt);
% imageFiles = imageFiles(sort_index);

imageSize = size(im2gray(imread(imageFiles{1})));
focalLength = [K(1,1) K(2,2)];
principalPoint = [K(1,3) K(2,3)];
intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);

%% Her er koden du trenger for å kjøre, alt over er bare lagt til for å få det til å kjøre
[features, valid_points] = find_features(imageFiles,intrinsics);
%% 
[G, matches] = find_match_graph(features, valid_points, imageFiles);
% sequence = dfsearch(G,1)';

%%
scale_factor = find_scale_factor(app.imagestxt);

    %%
num_imageFiles = size(imageFiles,1);
[relPose_cell, points3D_all] = get_relPosecell_and_3D_points(matches, sequence, intrinsics,num_imageFiles,K,scale_factor);

%% 
points3D_all = get_all_3D_points(points3D_all, num_imageFiles, matches, sequence, relPose_cell, intrinsics);
%%
%TODO: Z AND Y AXIS????
[app.origin, app.sideLengths] = get_global_coordinates_list(points3D_all);
app.DrawmodelButton.Visible = "on";