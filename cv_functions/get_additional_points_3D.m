function [points3D_all] = get_additional_points_3D(points3D_all, imagefiles_size, matches, sequence, relPose_cell, intrinsics)
    for i = 1:imagefiles_size-2
        for j = i:imagefiles_size-2
            if numel(matches{sequence(i),sequence(j)}) >15
                matchedPoints1 = matches{sequence(i),sequence(j)};
                matchedPoints2 = matches{sequence(j),sequence(i)};
    
                try
                    [E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, Confidence = 99.99);
                catch
                    continue;
                end
    
                % Find epipolar inliers
                inlierPoints1 = matchedPoints1(epipolarInliers, :);
                inlierPoints2 = matchedPoints2(epipolarInliers, :);
                
                rel_pose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);
                relative_pose.A(1:3,4) = (relative_pose.A(1:3,4))*scale_factor(i,i+1);   
                camMatrix1 = cameraProjection(intrinsics, rigidtform3d);
                camMatrix2 = cameraProjection(intrinsics, pose2extr(relPose(1)));
                points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
    
                points = transform_points(i,m,points3D,relPose_cell);
    
                points3D_all = [points3D_all; points];
        
            end
        end
    end
end