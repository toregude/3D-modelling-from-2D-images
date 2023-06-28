function [E, matchedPoints1_inliers,matchedPoints2_inliers] = match_features(I1, I2, K)    
    I1 = im2gray(I1);
    I2 = im2gray(I2);

    points1 = detectHarrisFeatures(I1);
    points2 = detectHarrisFeatures(I2);
    
    [features1,valid_points1] = extractFeatures(I1,points1);
    [features2,valid_points2] = extractFeatures(I2,points2);
    
    indexPairs = matchFeatures(features1,features2);
    
    matchedPoints1 = valid_points1(indexPairs(:,1),:);
    matchedPoints2 = valid_points2(indexPairs(:,2),:);

    focalLength = [K(1,1) K(2,2)];
    principalPoint = [K(1,3) K(2,3)];
    imageSize1 = size(I1);
    imageSize2 = size(I2);
    if imageSize1 ~= imageSize2
        "Conflicting image sizes! Fix this!"
    else
        imageSize = imageSize1;
    end
    intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
    
    [E,inliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics);
    
    matchedPoints1_inliers = matchedPoints1(inliers==1);
    matchedPoints2_inliers = matchedPoints2(inliers==1);

    %TRENGER VI DE FØLGENDE KODELINJENE EGENTLIG?
%     correspondences = [matchedPoints1_inliers.Location; matchedPoints2_inliers.Location];
%     figure; 
%     showMatchedFeatures(I1,I2,matchedPoints1_inliers,matchedPoints2_inliers);

%     [T1, T2, R1, R2] = TR_from_E(E);
%     
%     [T, R, lambda, P1, camC1, camC2] = reconstruction(T1, T2, R1, R2, correspondences, K)
end