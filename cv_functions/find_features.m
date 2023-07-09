function [features, valid_points] = find_features(imageFiles,intrinsics)
    features = cell(1,size(imageFiles,1));
    valid_points = cell(1,size(imageFiles,1));
    imageSize = size(im2gray(imread(imageFiles{1})));
    for i = 1:size(imageFiles,1)
        I = im2gray(undistortImage(imread(imageFiles{i}),intrinsics));
        I = imresize(I, imageSize);
        harrisFeatures = detectHarrisFeatures(I);
        [features,validCorners] = extractFeatures(I,harrisFeatures);
        features{i} = features;
        valid_points{i} = validCorners;
    end
end