function matches_matrix = get_matches_matrix(features_cell, valid_points_cell, image_files)
    matches_matrix = cell(size(image_files,1),size(image_files,1));

    %Populating the upper triangular part of matches_matrix with matches between image i and j,
    %so that more matched points may be found between images. All points will later
    %be transformed from the first to the last image frame
    for i = 1:size(image_files,1)
        for j = i+1:size(image_files,1)
            features1 = features_cell{i};
            features2 = features_cell{j};

            index_pairs = matchFeatures(features1.Features, features2.Features);

            valid_points1 = valid_points_cell{i};
            valid_points2 = valid_points_cell{j};

            matched_points1 = valid_points1.Location(index_pairs(:,1),:);
            matched_points2 = valid_points2.Location(index_pairs(:,2),:);
            
            %At least five matched points are needed from each image to later compute E, but it gives better results with 8
            if and(length(matched_points1)>7, length(matched_points2)>7)
                matches_matrix{i,j} = matched_points1;
                matches_matrix{j,i} = matched_points2;
            end
        end
    end
end