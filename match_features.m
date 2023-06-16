I1 = im2gray(imread("Prosjekt/DSC_0675.JPG"));
I2 = im2gray(imread("Prosjekt/DSC_0676.JPG"));

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

[E,inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2,Method="RANSAC", NumTrials=2000,DistanceThreshold=1e-3);

matchedPoints1_inliers = matchedPoints1(inliers==1);
matchedPoints2_inliers = matchedPoints2(inliers==1);

figure; 
showMatchedFeatures(I1,I2,matchedPoints1_inliers,matchedPoints2_inliers);

