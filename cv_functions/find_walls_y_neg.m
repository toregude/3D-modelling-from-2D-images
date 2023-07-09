function valid_wall_list = find_walls_y_neg(global_coords)
    data = global_coords;
    min_y = -50.;
    max_y = 50.;
    delta_y = 0.05;
    y = min_y:delta_y:max_y;
    y = sort(y,'descend');
    last_count = 0;
    y_level = max_y;
    valid_wall_list = [];
    x_min = 0;
    x_max = 0;
    x_min_last = 0;
    x_max_last = 0;
    for i = 1:length(y)-20
        count = length(data(data(:, 2) > y(i+1))) - length(data(data(:, 2) >= y(i)));
        if count < 20
            last_count = count;
            continue;
        else
            if (count/last_count > 5) || (count > 100) 
                y_level = y(i-20);
                mulige_coords = global_coords(global_coords(:,2)<=y(i) & global_coords(:,2)>y(i+20), :)
                x_coords = mulige_coords(:, 1);
                x_coords = sort(x_coords, "ascend")
                x_max = x_coords(end);
                x_min = x_coords(1);
                if size(valid_wall_list, 2) == 0
                    valid_wall_list = [valid_wall_list; [y_level, x_min, x_max]];
                    x_max_last = x_max;
                    x_min_last = x_min;
                    continue;
                end
                if x_min < x_min_last - 1
                    valid_wall_list = [valid_wall_list; [y_level, x_min, x_min_last]];
                    x_min_last = x_min; 
                end
                if x_max > x_max_last + 1
                    valid_wall_list = [valid_wall_list; [y_level, x_max_last, x_max]];
                    x_max_last = x_max; 
                end
            end
        end
    end
end