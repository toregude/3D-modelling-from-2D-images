function [points_3D_array] = get_points_3D_array(matches, intrinsics, relative_pose_cell)

    points_3D_array = [];
    [m, n] = size(matches);

    for i = 1:(m-1)
        points_3D_frame_i = [];

        for j = i+1:n
            matched_points1 = matches{i, j};
            matched_points2 = matches{j, i};
        
            %If there are too few matched points, then the essential matrix can not be found.
            if or(size(matched_points1,1)<=5,size(matched_points2,1)<=5)
                continue
            end

            relative_pose = relative_pose_cell{i,j};

            cam_matrix1 = cameraProjection(intrinsics, rigidtform3d);
            cam_matrix2 = cameraProjection(intrinsics, pose2extr(relative_pose));
        
            points_3D = triangulate(matched_points1, matched_points2, cam_matrix1, cam_matrix2);
            
            points_3D_frame_i = [points_3D_frame_i; points_3D];
        end
        
        points_3D_array = transformPointsForward(relative_pose_cell{i,i+1}, [points_3D_array; points_3D_frame_i]);
    end
end