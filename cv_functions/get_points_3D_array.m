function [points_3D_array] = get_points_3D_array(matches_matrix, camera_intrinsics, relative_pose_cell)

    points_3D_array = [];
    [m, n] = size(matches_matrix);
    
    for i = 1:(m-1)
        points_3D_frame_i = [];

        for j = i+1:n
            matched_points1 = matches_matrix{i, j};
            matched_points2 = matches_matrix{j, i};
        
            %If there are too few matched points, then the essential matrix can not be found.
            if or(size(matched_points1,1)<=7,size(matched_points2,1)<=7)
                continue
            end

            relative_pose = relative_pose_cell{i,j};

            cam_matrix1 = cameraProjection(camera_intrinsics, rigidtform3d);
            cam_matrix2 = cameraProjection(camera_intrinsics, pose2extr(relative_pose));
        
            points_3D = triangulate(matched_points1, matched_points2, cam_matrix1, cam_matrix2);
            
            points_3D_frame_i = [points_3D_frame_i; points_3D];
        end
        
        %transformPointsForward does not work with an empty points set
        if ~isempty([points_3D_array; points_3D_frame_i])
            points_3D_array = transformPointsForward(relative_pose_cell{i,j}, [points_3D_array; points_3D_frame_i]);
        end
    end
end