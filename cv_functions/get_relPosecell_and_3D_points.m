function [relPose_cell, points3D_all] = get_relPosecell_and_3D_points(matches, sequence, intrinsics,num_imageFiles)
    relPose_cell = cell(1,num_imageFiles-1);
    points3D_all = [];
    for i = 1:num_imageFiles-2 % Usikker på hvorfor det må være -2 og ikke -1, virker som at siste bildet ikke blir sortert
        %Regn ut 3D kordinater
        matchedPoints1 = matches{sequence(i),sequence(i+1)};
        matchedPoints2 = matches{sequence(i+1),sequence(i)};
        [E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, 'Confidence', 99.99);
    
        % Find epipolar inliers
        inlierPoints1 = matchedPoints1(epipolarInliers, :);
        inlierPoints2 = matchedPoints2(epipolarInliers, :);
        
        relPose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);
        relPose = relPose(1);
        relPose_cell{i} = relPose;
    
        camMatrix1 = cameraProjection(intrinsics, rigidtform3d);
        camMatrix2 = cameraProjection(intrinsics, pose2extr(relPose));
    
        % % Compute the 3-D points
        points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
        
        points3D_all = transformPointsForward(relPose, [points3D_all; points3D]);
    end
end