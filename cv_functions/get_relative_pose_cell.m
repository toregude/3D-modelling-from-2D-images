function [relative_pose_cell, matches] = get_relative_pose_cell(matches, intrinsics, scale_factor)
    
    [m, n] = size(matches);
    relative_pose_cell = cell(m,n);

    for i = 1:m
        for j = i+1:n
            matched_points1 = matches{i, j};
            matched_points2 = matches{j, i};
        
            %If there are too few matched points, then the essential matrix can not be found.
            if or(size(matched_points1,1)<=10,size(matched_points2,1)<=10)
                relative_pose_cell{i,j} = rigidtform3d; %When disruption, assign R=I, T=0.
                continue
            end
    
            warning('off'); %This is needed due to the high confidence of the essential matrix estimation.
            try
                [E, epipolar_inliers] = estimateEssentialMatrix(matched_points1, matched_points2, intrinsics, 'Confidence', 90);
                inlier_points1 = matched_points1(epipolar_inliers, :);
                inlier_points2 = matched_points2(epipolar_inliers, :);
        
                relative_pose = estrelpose(E, intrinsics, inlier_points1, inlier_points2);
            catch
                relative_pose_cell{i,j} = rigidtform3d; %When disruption, assign R=I, T=0.
                matches{i,j} = [];
                matches{j,i} = [];
                continue
            end
            warning('on');
            
            %The relative_pose object might contain more than one alternative for T and R. The first alternative is chosen.
            if size(relative_pose,1)>1
                relative_pose = relative_pose(1);
            end
            
            %Changing the scale of the translation part of the relative pose
            relative_pose.A(1:3,4) = (relative_pose.A(1:3,4))*scale_factor(i,j);       
            relative_pose_cell{i,j} = relative_pose;
        end
    end
end