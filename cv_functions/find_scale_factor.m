function scale_factor = find_scale_factor(allData, matches)

    
    try
        campos_seq = allData(:, 2:4);
        scale_factor = zeros(size(allData,1)-1,1);
        for i = 1:size(allData,1)-1
            scale_factor(i) = (abs(campos_seq(i)-campos_seq(i+1)));
        end
    catch
        scale_factor = ones(size(allData,1)-1,1);
    end
    if isnan(scale_factor)
        scale_factor = ones(size(allData,1)-1,1);
    end
end
