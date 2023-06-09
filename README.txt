In this repository, one can add a minumum of two images of a room to get a 3D model of the room, with sizes and distances
of all objects visible in the pictures. 

List of toolboxes used:
- points = detectHarrisFeatures(I)
- indexPairs = matchFeatures(features1,features2)
- RGB = insertMarker(I,position)
- showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2)


I1 = im2gray(imread("Prosjekt/DSC_6487.JPG"));
I2 = im2gray(imread("Prosjekt/DSC_6487.JPG"));

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure; 
