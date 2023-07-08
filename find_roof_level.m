

function roof_level = find_roof_level(data)
    minimum_roof = -10.;
    maximum_roof = 10.;
    delta_z = 0.05;
    z = minimum_roof:delta_z:maximum_roof;
    z = sort(z, 'descend');
    last_count = 0;
    roof_level = minimum_roof;
    for i = 1:(length(z)-1)
        count = length(data(data(:, 3) > z(i+1))) - length(data(data(:, 3) >= z(i)));
        if count < 20
            last_count = count;
            continue;
        else
            if count/last_count > 5
                roof_level = z(i);
                break;
            end
        end
    end
end