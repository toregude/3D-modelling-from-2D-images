function [features, valid_points] = find_features(imageFiles,intrinsics)
    features = cell(1,size(imageFiles,1));
    valid_points = cell(1,size(imageFiles,1));
    imageSize = size(im2gray(imread(imageFiles{1})));
    for i = 1:size(imageFiles,1)
        I1 = im2gray(undistortImage(imread(imageFiles{i}),intrinsics));
        if i == 5
            I1 = I1';
        end
        I1 = imresize(I1, imageSize);
        harrisFeatures1 = detectHarrisFeatures(I1);
        [features1,validCorners1] = extractFeatures(I1,harrisFeatures1);
        features{i} = features1;
        valid_points{i} = validCorners1;
    end
end