function scale_factor = find_scale_factor(allData)
    % campos_seq = allData(:, 2:4);
    try
        scale_factor = zeros(size(allData,1)-1,1);
        for i = 1:size(allData,1)-1
            scale_factor(i) = (abs(allData(i)-allData(i+1)));
        end
    catch
        scale_factor = ones(1,size(allData,1)-1);
    end
end