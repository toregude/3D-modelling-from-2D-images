%% Tores feature matching
I1 = im2gray(imread("DSC_0682.JPG"));
I2 = im2gray(imread("DSC_0684.JPG"));

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

showMatchedFeatures(I1, I2, matchedPoints1, matchedPoints2);
