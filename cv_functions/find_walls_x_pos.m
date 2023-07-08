function valid_wall_list = find_walls_x_pos(global_coords)
    data = global_coords;
    min_x = -30.;
    max_x = 30.;
    delta_x = 0.1;
    x = min_x:delta_x:max_x;
    last_count = 0;
    x_level = min_x;
    valid_wall_list = [];
    y_min = 0;
    y_max = 0;
    y_min_last = 0;
    y_max_last = 0;
    for i = 1:length(x)-3
        count = length(data(data(:, 1) < x(i+1))) - length(data(data(:, 1) <= x(i)));
        if count < 10
            last_count = count;
            continue;
        else
            if count/last_count > 5
                x_level = x(i);
                mulige_coords = global_coords(global_coords(:,1)>=x(i) & global_coords(:,1)<x(i+3), :)
                y_coords = mulige_coords(:, 2);
                y_coords = sort(y_coords, "ascend")
                y_max = y_coords(end);
                y_min = y_coords(1);
                if size(valid_wall_list, 2) == 0
                    valid_wall_list = [valid_wall_list; [x_level, y_min, y_max]];
                    y_max_last = y_max;
                    y_min_last = y_min;
                    continue;
                end
                if y_min < y_min_last - 1
                    valid_wall_list = [valid_wall_list; [x_level, y_min, y_min_last]];
                    y_min_last = y_min; 
                end
                if y_max > y_max_last + 1
                    valid_wall_list = [valid_wall_list; [x_level, y_max_last, y_max]];
                    y_max_last = y_max; 
                end
            end
        end
    end
end