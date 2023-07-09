function [relative_pose_cell, points_3D_array] = get_relative_pose_and_points_3D(matches, intrinsics, scale_factor)
    num_images = size(matches,1);

    relative_pose_cell = cell(1,num_images-1);
    points_3D_array = [];

    for i = 1:(num_images-1)
        matched_points1 = matches{i, i+1};
        matched_points2 = matches{i+1, i};
    
        %If there are too few matched points, then the essential matrix can not be found
        if or(size(matched_points1,1)<=5,size(matched_points2,1)<=5)
            continue
        end

        warning('off'); %This is needed due to the high confidence of the essential matrix estimation
        [E, epipolar_inliers] = estimateEssentialMatrix(matched_points1, matched_points2, intrinsics, 'Confidence', 99.99);
        warning('on');

        inlier_points1 = matched_points1(epipolar_inliers, :);
        inlier_points2 = matched_points2(epipolar_inliers, :);

        relative_pose = estrelpose(E, intrinsics, inlier_points1, inlier_points2);
        
        %The relative_pose object might contain more than one alternative for T and R
        if size(relative_pose,1)>1
            relative_pose = relative_pose(1);
        end
 
        relative_pose.A(1:3,4) = (relative_pose.A(1:3,4))*scale_factor(i);       
        relative_pose_cell{i} = relative_pose;
    
        cam_matrix1 = cameraProjection(intrinsics, rigidtform3d);
        cam_matrix2 = cameraProjection(intrinsics, pose2extr(relative_pose));
    
        points_3D = triangulate(matched_points1, matched_points2, cam_matrix1, cam_matrix2);
        
        points_3D_array = transformPointsForward(relative_pose, [points_3D_array; points_3D]);
    end
end