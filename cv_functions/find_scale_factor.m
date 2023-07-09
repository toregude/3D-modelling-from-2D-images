function scale_factor = find_scale_factor(allData, matches)
    scale_factor = zeros(size(matches)); 
    for i = 1:size(matches,1)
        for j = 1:size(matches,2)
            if ~isempty(matches{i,j})
                try
                    scale_factor(i,j) = (norm(allData(i, 2:4)-allData(j, 2:4)));
                catch
                    scale_factor(i,j) = 1;
                end
            else
                scale_factor(i,j) = 0;
            end
        end
    end
end
