function floor_level = find_floor_level(data)
    minimum_floor = -10.;
    maximum_floor = 10.;
    delta_z = 0.05;
    z = minimum_floor:delta_z:maximum_floor;
    last_count = 0;
    floor_level = minimum_floor;
    for i = 1:(length(z)-1)
        count = length(data(data(:, 3) < z(i+1))) - length(data(data(:, 3) <= z(i)));
        if count < 20
            last_count = count;
            continue;
        else
            if count/last_count > 5
                floor_level = z(i);
                break;
            end
        end
    end
end