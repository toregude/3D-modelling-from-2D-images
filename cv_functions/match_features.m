function [E, matchedPoints1_inliers,matchedPoints2_inliers] = match_features(I1, I2, K)    
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
    correspondences = [matchedPoints1_inliers.Location, matchedPoints2_inliers.Location];
    figure; 
    showMatchedFeatures(I1,I2,matchedPoints1_inliers,matchedPoints2_inliers);

    [T1, T2, R1, R2, U, V] = TR_from_E(E);
    
    [T, R, lambda, P1, camC1, camC2] = reconstruction(T1, T2, R1, R2, correspondences', K)
end