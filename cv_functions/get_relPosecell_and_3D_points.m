function [relPose_cell, points3D_all] = get_relPosecell_and_3D_points(matches, sequence, intrinsics,num_imageFiles,K,scale_factor)
    relPose_cell = cell(1,num_imageFiles-1);
    points3D_all = [];
    warning('off');
    for i = 1:num_imageFiles-2 % Usikker på hvorfor det må være -2 og ikke -1, virker som at siste bildet ikke blir sortert
        "Så langt kommer vi"
        i
        
        %Regn ut 3D kordinater
        matchedPoints1 = matches{sequence(i),sequence(i+1)};
        matchedPoints2 = matches{sequence(i+1),sequence(i)};
        [E, epipolarInliers] = estimateEssentialMatrix(matchedPoints1, matchedPoints2, intrinsics, 'Confidence', 99.99);
    
        % Find epipolar inliers
        inlierPoints1 = matchedPoints1(epipolarInliers, :);
        inlierPoints2 = matchedPoints2(epipolarInliers, :);

        relPose = estrelpose(E, intrinsics, inlierPoints1, inlierPoints2);
        if size(relPose,1)>1
            T = cell(size(relPose,1),1);
            for j =1:size(relPose,1)
                T{j} = relPose(j).A;
            end
            relPose = estrelpose(E, intrinsics, matchedPoints1, matchedPoints2);
        end
    
        if size(relPose,1) > 1
            point = [0,0,0,1]';
            best = 1;
            prevPoint = inf(4,1);
            
            
            for j = 1:size(relPose,1)
                idxToRemove = 0;
                for k = 1:size(T,1)
                    if (isequal(T{k}, relPose(j).A))
                        idxToRemove = j;
                        break;
                    end
                end

                if idxToRemove==0
                    continue;
                end
                rotatedPoint = (relPose(j).A)*point;
                if abs(prevPoint(2)) > abs(rotatedPoint(2))
                    prevPoint = rotatedPoint;
                    best = j;
                end
            end
            if size(relPose,1) >1
                relPose = relPose(best);
            end
        end
 
        relPose.A(1:3,4) = (relPose.A(1:3,4))*scale_factor(i);       
        relPose_cell{i} = relPose;
    
        camMatrix1 = cameraProjection(intrinsics, rigidtform3d);
        camMatrix2 = cameraProjection(intrinsics, pose2extr(relPose));
    
        % % Compute the 3-D points
        points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);
        
        points3D_all = transformPointsForward(relPose, [points3D_all; points3D]);
    end
    warning('on');
end