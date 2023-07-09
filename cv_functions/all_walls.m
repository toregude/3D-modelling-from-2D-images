

function [valid_wall_list_x_pos, valid_wall_list_x_neg, valid_wall_list_y_pos, valid_wall_list_y_neg] = all_walls(global_coords)
    %% general
    data = global_coords;
    min_x = -50.;
    max_x = 50.;
    delta_x = 0.05;

    min_y = -50.;
    max_y = 50.;
    delta_y = 0.05;
    %% x_pos
    x = min_x:delta_x:max_x;
    last_count = 0;
    x_level = min_x;
    valid_wall_list_x_pos = [];
    y_min = 0;
    y_max = 0;
    y_min_last = 0;
    y_max_last = 0;
    for i = 1:length(x)-20
        count = length(data(data(:, 1) < x(i+1))) - length(data(data(:, 1) <= x(i)));
        if count < 20
            last_count = count;
            continue;
        else
            if (count/last_count > 5) || (count > 100) 
                x_level = x(i-20);
                mulige_coords = global_coords(global_coords(:,1)>=x(i) & global_coords(:,1)<x(i+20), :);
                y_coords = mulige_coords(:, 2);
                y_coords = sort(y_coords, "ascend");
                y_max = y_coords(end);
                y_min = y_coords(1);
                if size(valid_wall_list_x_pos, 2) == 0
                    valid_wall_list_x_pos = [valid_wall_list_x_pos; [x_level, y_min, y_max]];
                    y_max_last = y_max;
                    y_min_last = y_min;
                    continue;
                end
                if y_min < y_min_last - 0.1
                    valid_wall_list_x_pos = [valid_wall_list_x_pos; [x_level, y_min, y_min_last]];
                    y_min_last = y_min; 
                end
                if y_max > y_max_last + 0.1
                    valid_wall_list_x_pos = [valid_wall_list_x_pos; [x_level, y_max_last, y_max]];
                    y_max_last = y_max; 
                end
            end
        end
    end

    %% x_neg
    x = sort(x,'descend');
    last_count = 0;
    x_level = max_x;
    valid_wall_list_x_neg = [];
    y_min = 0;
    y_max = 0;
    y_min_last = 0;
    y_max_last = 0;
    for i = 1:length(x)-20
        count = length(data(data(:, 1) > x(i+1))) - length(data(data(:, 1) >= x(i)));
        if count < 20
            last_count = count;
            continue;
        else
            if (count/last_count > 5) || (count > 100) 
                x_level = x(i-20);
                mulige_coords = global_coords(global_coords(:,1)<=x(i) & global_coords(:,1)>x(i+20), :);
                y_coords = mulige_coords(:, 2);
                y_coords = sort(y_coords, "ascend");
                y_max = y_coords(end);
                y_min = y_coords(1);
                if size(valid_wall_list_x_neg, 2) == 0
                    valid_wall_list_x_neg = [valid_wall_list_x_neg; [x_level, y_min, y_max]];
                    y_max_last = y_max;
                    y_min_last = y_min;
                    continue;
                end
                if y_min < y_min_last - 0.1
                    valid_wall_list_x_neg = [valid_wall_list_x_neg; [x_level, y_min, y_min_last]];
                    y_min_last = y_min; 
                end
                if y_max > y_max_last + 0.1
                    valid_wall_list_x_neg = [valid_wall_list_x_neg; [x_level, y_max_last, y_max]];
                    y_max_last = y_max; 
                end
            end
        end
    end

    %% y_pos
    y = min_y:delta_y:max_y;
    last_count = 0;
    y_level = min_y;
    valid_wall_list_y_pos = [];
    x_min = 0;
    x_max = 0;
    x_min_last = 0;
    x_max_last = 0;
    for i = 1:length(y)-20
        count = length(data(data(:, 2) < y(i+1))) - length(data(data(:, 2) <= y(i)));
        if count < 20
            last_count = count;
            continue;
        else
            if (count/last_count > 5) || (count > 100) 
                y_level = y(i-20);
                mulige_coords = global_coords(global_coords(:,2)>=y(i) & global_coords(:,2)<y(i+20), :);
                x_coords = mulige_coords(:, 1);
                x_coords = sort(x_coords, "ascend");
                x_max = x_coords(end);
                x_min = x_coords(1);
                if size(valid_wall_list_y_pos, 2) == 0
                    valid_wall_list_y_pos = [valid_wall_list_y_pos; [y_level, x_min, x_max]];
                    x_max_last = x_max;
                    x_min_last = x_min;
                    continue;
                end
                if x_min < x_min_last - 0.1
                    valid_wall_list_y_pos = [valid_wall_list_y_pos; [y_level, x_min, x_min_last]];
                    x_min_last = x_min; 
                end
                if x_max > x_max_last + 0.1
                    valid_wall_list_y_pos = [valid_wall_list_y_pos; [y_level, x_max_last, x_max]];
                    x_max_last = x_max; 
                end
            end
        end
    end

    %% y_neg
    y = sort(y,'descend');
    last_count = 0;
    y_level = max_y;
    valid_wall_list_y_neg = [];
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
                mulige_coords = global_coords(global_coords(:,2)<=y(i) & global_coords(:,2)>y(i+20), :);
                x_coords = mulige_coords(:, 1);
                x_coords = sort(x_coords, "ascend");
                x_max = x_coords(end);
                x_min = x_coords(1);
                if size(valid_wall_list_y_neg, 2) == 0
                    valid_wall_list_y_neg = [valid_wall_list_y_neg; [y_level, x_min, x_max]];
                    x_max_last = x_max;
                    x_min_last = x_min;
                    continue;
                end
                if x_min < x_min_last - 0.1
                    valid_wall_list_y_neg = [valid_wall_list_y_neg; [y_level, x_min, x_min_last]];
                    x_min_last = x_min; 
                end
                if x_max > x_max_last + 0.1
                    valid_wall_list_y_neg = [valid_wall_list_y_neg; [y_level, x_max_last, x_max]];
                    x_max_last = x_max; 
                end
            end
        end
    end

    %% Fikse litt
    list_of_walls_y_new = [];
    list_of_walls_x_new = [];
    list_of_walls_x_neg_new = [];
    list_of_walls_y_neg_new = [];

    y_pos_temp = valid_wall_list_y_pos(1, 1);
    y_neg_temp = valid_wall_list_y_neg(1, 1);
    x_pos_temp = valid_wall_list_x_pos(1, 1);
    x_neg_temp = valid_wall_list_x_neg(1, 1);
    for i = 1:size(valid_wall_list_y_pos, 1)-1
        if (abs(y_pos_temp - valid_wall_list_y_pos(i+1,1)) < 2) || (abs(valid_wall_list_y_pos(i+1,2) - valid_wall_list_y_pos(i+1, 3)) < 2)
            y_pos_temp = valid_wall_list_y_pos(i,1);
            valid_wall_list_y_pos(i+1, 1) = valid_wall_list_y_pos(i,1);
        end
    end
    if (abs(y_pos_temp - valid_wall_list_y_pos(end,1)) < 2) || (abs(valid_wall_list_y_pos(end,2) - valid_wall_list_y_pos(end, 3)) < 2)
        valid_wall_list_y_pos(end, 1) = y_pos_temp;
    end
    for i = 1:size(valid_wall_list_y_neg, 1)-1
        if (abs(y_neg_temp - valid_wall_list_y_neg(i+1,1)) < 2) || (abs(valid_wall_list_y_neg(i+1,2) - valid_wall_list_y_neg(i+1, 3)) < 2)
            y_neg_temp = valid_wall_list_y_neg(i,1);
            valid_wall_list_y_neg(i+1, 1) = valid_wall_list_y_neg(i,1);
        end
    end
    if (abs(y_neg_temp - valid_wall_list_y_neg(end,1)) < 2) || (abs(valid_wall_list_y_neg(end,2) - valid_wall_list_y_neg(end, 3)) < 2)
        valid_wall_list_y_neg(end, 1) = y_neg_temp;
    end
    for i = 1:size(valid_wall_list_x_pos, 1)-1
        if (abs(x_pos_temp - valid_wall_list_x_pos(i+1,1)) < 2) || (abs(valid_wall_list_x_pos(i+1,2) - valid_wall_list_x_pos(i+1, 3)) < 2)
            x_pos_temp = valid_wall_list_x_pos(i,1);
            valid_wall_list_x_pos(i+1, 1) = valid_wall_list_x_pos(i,1);
        end
    end
    if (abs(x_pos_temp - valid_wall_list_x_pos(end,1)) < 2) || (abs(valid_wall_list_x_pos(end,2) - valid_wall_list_x_pos(end, 3)) < 2)
        valid_wall_list_x_pos(end, 1) = x_pos_temp;
    end
    for i = 1:size(valid_wall_list_x_neg, 1)-1
        if (abs(x_neg_temp - valid_wall_list_x_neg(i+1,1)) < 2) || (abs(valid_wall_list_x_neg(i+1,2) - valid_wall_list_x_neg(i+1, 3)) < 2)
            x_neg_temp = valid_wall_list_x_neg(i,1);
            valid_wall_list_x_neg(i+1, 1) = valid_wall_list_x_neg(i,1);
        end
    end
    if (abs(x_neg_temp - valid_wall_list_x_neg(end,1)) < 2) || (abs(valid_wall_list_x_neg(end,2) - valid_wall_list_x_neg(end, 3)) < 2)
        valid_wall_list_x_neg(end, 1) = x_neg_temp;
    end

    x_pos_values = unique(valid_wall_list_x_pos(:,1));
    x_neg_values = unique(valid_wall_list_x_neg(:,1));
    y_pos_values = unique(valid_wall_list_y_pos(:,1));
    y_neg_values = unique(valid_wall_list_y_neg(:,1));

    new_x_pos = [];
    new_x_neg = [];
    new_y_pos = [];
    new_y_neg = [];

    for i = 1:length(x_pos_values)
        new_x_pos = [new_x_pos; [x_pos_values(i), min(valid_wall_list_x_pos(valid_wall_list_x_pos(:, 1) == x_pos_values(i), 2)), max(valid_wall_list_x_pos(valid_wall_list_x_pos(:, 1) == x_pos_values(i), 3))]];
    end
    for i = 1:length(x_neg_values)
        new_x_neg = [new_x_neg; [x_neg_values(i), min(valid_wall_list_x_neg(valid_wall_list_x_neg(:, 1) == x_neg_values(i), 2)), max(valid_wall_list_x_neg(valid_wall_list_x_neg(:, 1) == x_neg_values(i), 3))]];
    end
    for i = 1:length(y_pos_values)
        new_y_pos = [new_y_pos; [y_pos_values(i), min(valid_wall_list_y_pos(valid_wall_list_y_pos(:, 1) == y_pos_values(i), 2)), max(valid_wall_list_y_pos(valid_wall_list_y_pos(:, 1) == y_pos_values(i), 3))]];
    end
    for i = 1:length(y_neg_values)
        new_y_neg = [new_y_neg; [y_neg_values(i), min(valid_wall_list_y_neg(valid_wall_list_y_neg(:, 1) == y_neg_values(i), 2)), max(valid_wall_list_y_neg(valid_wall_list_y_neg(:, 1) == y_neg_values(i), 3))]];
    end
    valid_wall_list_x_pos = new_x_pos;
    valid_wall_list_x_neg = new_x_neg;
    valid_wall_list_y_pos = new_y_pos;
    valid_wall_list_y_neg = new_y_neg;

    % a = valid_wall_list_x_pos(end, 1);
    % b = valid_wall_list_x_neg(1, 1);
    % c = valid_wall_list_x_pos(end, 1);
    % d = valid_wall_list_x_neg(1, 1);
    % 
    % valid_wall_list_y_neg(end,2) = a;
    % valid_wall_list_y_neg(end,3) = b;
    % valid_wall_list_y_pos(1,2) = c;
    % valid_wall_list_y_pos(1,3) = d;
    % 
    % valid_wall_list_x_pos(1, 2) = valid_wall_list_y_pos(1,1);
    % valid_wall_list_x_pos(1, 3) = valid_wall_list_y_pos(1,1);
    % valid_wall_list_x_neg(end, 2) = valid_wall_list_y_pos(1,1);
    % valid_wall_list_x_neg(end, 3) = valid_wall_list_y_pos(1,1);

    valid_wall_list_x_neg(end, 1) = max([valid_wall_list_y_pos(:, 3);  valid_wall_list_y_neg(:, 3)]);
    valid_wall_list_x_pos(1, 1) = min([valid_wall_list_y_pos(:, 2);  valid_wall_list_y_neg(:, 2)]);
    valid_wall_list_y_neg(end, 1) = max([valid_wall_list_x_pos(:, 3);  valid_wall_list_x_neg(:, 3)]);
    valid_wall_list_y_pos(1, 1) = min([valid_wall_list_x_pos(:, 2);  valid_wall_list_x_neg(:, 2)]);
    valid_wall_list_y_neg(end, 2) = valid_wall_list_x_pos(end, 1);
    valid_wall_list_y_neg(end, 3) = valid_wall_list_x_neg(1, 1);
    valid_wall_list_y_pos(1, 2) = valid_wall_list_x_pos(end, 1);
    valid_wall_list_y_pos(1, 3) = valid_wall_list_x_neg(1, 1);

    [~,idx] = max(valid_wall_list_y_pos(:,3));
    valid_wall_list_x_neg(end, 2) = valid_wall_list_y_pos(idx, 1);
    [~,idx] = max(valid_wall_list_y_neg(:,3));
    valid_wall_list_x_neg(end, 3) = valid_wall_list_y_neg(idx, 1);

    [~,idx] = min(valid_wall_list_y_pos(:,2));
    valid_wall_list_x_pos(1, 2) = valid_wall_list_y_pos(idx, 1);
    [~,idx] = min(valid_wall_list_y_neg(:,2));
    valid_wall_list_x_pos(1, 3) = valid_wall_list_y_neg(idx, 1);
    
    
    xp = valid_wall_list_x_pos;
    xn = valid_wall_list_x_neg;
    yp = valid_wall_list_y_pos;
    yn = valid_wall_list_y_neg;

    xpnew = [];
    xnnew = [];
    ypnew = [];
    ynnew = [];
    

    ynmin = yn(end, 2);
    ynmax = yn(end, 3);
    ypmin = yp(1, 2);
    ypmax = yp(1, 3);
    xnmin = xp(end, 2);
    xnmax = xn(end, 3);
    xpmin = xp(1, 2);
    xpmax = xp(1, 3);
    
    ynn = yn(yn(:, 2) <= ynmin, :)
    ynp = yn(yn(:, 3) >= ynmax, :)
    ypn = yp(yp(:, 2) <= ypmin, :)
    ypp = yp(yp(:, 3) >= ypmax, :)
    xnn = xn(xn(:, 2) <= xnmin, :)
    xnp = xn(xn(:, 3) >= xnmax, :)
    xpn = xp(xp(:, 2) <= xpmin, :)
    xpp = xp(xp(:, 3) >= xpmax, :)
    % % xpnew = [xpnew; [yn(2, 2), yn(1, 1), yn(2, 1)]];
    % % xpnew = [xpnew; [yn(4, 2), yn(2, 1), yn(4, 1)]];
    % % xpnew = [xpnew; [xpmax, yp(1, 1), yp(2, 1)]];
    for i = 1:size(ynn, 1)
        if ynn(i, 3) < ynmin & ynn(end, 2) ~= ynmin
            yn
    ynnew = [ynn;ynp];
    ypnew = [ypn;ypp];
    xnnew = [xnn;xnp];
    xpnew = [xpn;xpp];
    valid_wall_list_x_pos = xpnew;
    valid_wall_list_x_neg = xnnew;
    valid_wall_list_y_pos = ypnew;
    valid_wall_list_y_neg = ynnew;

    

end