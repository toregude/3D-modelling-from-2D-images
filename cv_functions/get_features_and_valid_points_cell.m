function [features_cell, valid_points_cell] = get_features_and_valid_points_cell(image_files,intrinsics)
    %Loop through all images and store the features and valid points in a cell
    %Handles images of different size, resizing all images to the size of
    %the first image

    features_cell = cell(1,size(image_files,1));
    valid_points_cell = cell(1,size(image_files,1));
    image_size = size(im2gray(imread(image_files{1})));

    for i = 1:size(image_files, 1)
        I = im2gray(undistortImage(imread(image_files{i}),intrinsics));
        I = imresize(I, image_size);

        harris_features = detectHarrisFeatures(I);
        [features, valid_points] = extractFeatures(I, harris_features);
        
        features_cell{i} = features;
        valid_points_cell{i} = valid_points;
    end
end