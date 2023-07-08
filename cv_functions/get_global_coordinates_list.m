function [senterliste, lengdeliste] =  get_global_coordinates_list(data)
    
    % path = '.\delivery_area_dslr_undistorted (ONLY FOR DEBUGGING)\delivery_area\dslr_calibration_undistorted\points3D.txt';
    
    % global_coordinates = get_global_coordinates_list_test(path);
    
    % Må kjøre toreTry3Dcordinates.m først
    %scatter3(global_coordinates(1,:),global_coordinates(2,:), global_coordinates(3,:))
    
    % Create a sample point cloud data in a list format
    
    floor_level = find_floor_level(data)
    % [
    %     1.2, 3.4, 2.1;
    %     2.3, 1.5, 4.2;
    %     5.6, 2.4, 3.1;
    %     2.0, 4.7, 1.8;
    %     % Add more points as needed
    % ];
    roof_level = find_roof_level(data);
    
    
    [idx, corepoints] = dbscan(data, 0.2, 20);
    numObjects = length(unique(idx)) - 1;
    
    max_room = max(data(idx ~= -1, 1:2));
    min_room = min(data(idx ~= -1, 1:2));
    
    
    
    min_list = zeros(3,numObjects)';
    max_list = zeros(3,numObjects)';
    for i = 1:numObjects
        points_i = data(idx==i, :);
        max_list(i, :) = max(points_i);
        min_list(i, :) = min(points_i);
    end
    
    senterliste = zeros(numObjects, 3);
    lengdeliste = zeros(numObjects, 3);
    for i = 1:numObjects
        O = (min_list(i, :) + max_list(i, :))/2;
        lenX = max_list(i, 1) - min_list(i, 1);
        lenY = max_list(i, 2) - min_list(i, 2);
        lenZ = max_list(i, 3) - min_list(i, 3);
        lengder = [lenX, lenY, lenZ];
        senterliste(i, :) = O;
        lengdeliste(i ,:) = lengder;
    end

    figure
    hold on;
    for i = 1:numObjects
        draw_box(senterliste(i,:), lengdeliste(i,:));
    end
    
    X = [min_room(1), min_room(1), max_room(1), max_room(1)];
    Y = [min_room(2), max_room(2), max_room(2), min_room(2)];
    Z = [floor_level, floor_level, floor_level, floor_level];
    
    
    patch('XData', X, 'YData', Y, 'ZData', Z);
    list_of_walls_x = find_walls_x_pos(data(idx ~= -1, :));
    for i = 1:size(list_of_walls_x, 1)
        X = [list_of_walls_x(i, 1), list_of_walls_x(i, 1), list_of_walls_x(i, 1), list_of_walls_x(i, 1)];
        Y = [list_of_walls_x(i, 2), list_of_walls_x(i, 3), list_of_walls_x(i, 3), list_of_walls_x(i, 2)];
        Z = [floor_level, floor_level, roof_level, roof_level];
        patch('XData', X, 'YData', Y, 'ZData', Z, 'FaceColor','red');
        
    end

    list_of_walls_y = find_walls_y_pos(data(idx ~= -1, :));
    for i = 1:size(list_of_walls_y, 1)
        Y = [list_of_walls_y(i, 1), list_of_walls_y(i, 1), list_of_walls_y(i, 1), list_of_walls_y(i, 1)];
        X = [list_of_walls_y(i, 2), list_of_walls_y(i, 3), list_of_walls_y(i, 3), list_of_walls_y(i, 2)];
        Z = [floor_level, floor_level, roof_level, roof_level];
        patch('XData', X, 'YData', Y, 'ZData', Z, 'FaceColor','red');
        
    end
    
    list_of_walls_x_neg = find_walls_x_neg(data(idx ~= -1, :));
    for i = 1:size(list_of_walls_x_neg, 1)
        X = [list_of_walls_x_neg(i, 1), list_of_walls_x_neg(i, 1), list_of_walls_x_neg(i, 1), list_of_walls_x_neg(i, 1)];
        Y = [list_of_walls_x_neg(i, 2), list_of_walls_x_neg(i, 3), list_of_walls_x_neg(i, 3), list_of_walls_x_neg(i, 2)];
        Z = [floor_level, floor_level, roof_level, roof_level];
        patch('XData', X, 'YData', Y, 'ZData', Z, 'FaceColor','red');
        
    end
    
    list_of_walls_y_neg = find_walls_y_neg(data(idx ~= -1, :));
    for i = 1:size(list_of_walls_y_neg, 1)
        Y = [list_of_walls_y_neg(i, 1), list_of_walls_y_neg(i, 1), list_of_walls_y_neg(i, 1), list_of_walls_y_neg(i, 1)];
        X = [list_of_walls_y_neg(i, 2), list_of_walls_y_neg(i, 3), list_of_walls_y_neg(i, 3), list_of_walls_y_neg(i, 2)];
        Z = [floor_level, floor_level, roof_level, roof_level];
        patch('XData', X, 'YData', Y, 'ZData', Z, 'FaceColor','red');
        
    end

    
    % IKKE SLETT DENNE
    % % % for i = 1:size(data, 1)
    % % %     if (idx(i) == -1)
    % % %         continue
    % % %         % plot3(data(i, 1), data(i, 2), data(i, 3), 'r+', 'MarkerSize', 10);
    % % %         % hold on;
    % % %     else
    % % %         if (corepoints(i) == 1)
    % % %             plot3(data(i, 1), data(i, 2), data(i, 3), 'b.', 'MarkerSize', 10);
    % % %         else
    % % %             plot3(data(i, 1), data(i, 2), data(i, 3), 'g*', 'MarkerSize', 10);
    % % %         end
    % % %         hold on;
    % % %     end
    % % % 
    % % %     if mod(i, 1000) == 0
    % % %         i
    % % %     end
    % % % end
    hold off;
end




