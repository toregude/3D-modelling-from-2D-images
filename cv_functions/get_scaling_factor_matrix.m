function scaling_factor_matrix = get_scaling_factor_matrix(images_txt, matches_matrix)
    scaling_factor_matrix = zeros(size(matches_matrix)); 
    
    for i = 1:size(matches_matrix,1)
        for j = 1:size(matches_matrix,2)

            %If empty matches, it is impossible to calculate the translation, thus no need for a scaling factor
            if ~isempty(matches_matrix{i,j})
                try
                    scaling_factor_matrix(i,j) = (norm(images_txt(i, 2:4)-images_txt(j, 2:4)));
                catch
                    scaling_factor_matrix(i,j) = 1;
                end
                
            else
                scaling_factor_matrix(i,j) = 0;
            end
        end
    end
end
