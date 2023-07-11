function roof_level = find_roof_level(points_3D_array)
    
    %Setting parameters to arbitrary levels
    minimum_roof = -30.;
    maximum_roof = 30.;

    %Dividing the z-axis in intervals of 5 centimeter.
    delta_z = 0.05;
    z = minimum_roof:delta_z:maximum_roof;
    z = sort(z, 'descend');
    last_count = 0;
    roof_level = minimum_roof;
    
    %Loop to decide roof level. If we have more than 20 points in one z-level, and the gradient is bigger than 5, we have the roof level.
    for i = 1:(length(z)-1)
        count = length(points_3D_array(points_3D_array(:, 3) > z(i+1))) - length(points_3D_array(points_3D_array(:, 3) >= z(i)));
        if count < 20
            last_count = count;
            continue;
        else
            gradient = count/last_count;
            if gradient > 5
                roof_level = z(i);
                break;
            end
        end
    end
end