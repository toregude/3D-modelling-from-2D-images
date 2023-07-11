function floor_level = find_floor_level(points_3D_array)
    
    %Setting parameters to arbitrary levels
    minimum_floor = -10;
    maximum_floor = 10;

    %Dividing the z-axis in intervals of 5 centimeter.
    delta_z = 0.05;
    z = minimum_floor:delta_z:maximum_floor;
    last_count = 0;
    floor_level = minimum_floor;

    %Loop to decide floor level. If we have more than 20 points in one z-level, and the gradient is bigger than 5, we have the floor level.
    for i = 1:(length(z)-1)
        count = length(points_3D_array(points_3D_array(:, 3) < z(i+1))) - length(points_3D_array(points_3D_array(:, 3) <= z(i)));
        if count < 20
            last_count = count;
            continue;
        else
            gradient = count/last_count;
            if gradient > 5
                floor_level = z(i);
                break;
            end
        end
    end
end