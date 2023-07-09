function [senterliste, lengdeliste] = get_global_coordinates_list(points3D)
    
    % path = '.\delivery_area_dslr_undistorted (ONLY FOR DEBUGGING)\delivery_area\dslr_calibration_undistorted\points3D.txt';
    
    
    
    % Må kjøre toreTry3Dcordinates.m først
    %scatter3(global_coordinates(1,:),global_coordinates(2,:), global_coordinates(3,:))
    
    % Create a sample point cloud data in a list format
    data = points3D;
    
    floor_level = find_floor_level(data)
    % [
    %     1.2, 3.4, 2.1;
    %     2.3, 1.5, 4.2;
    %     5.6, 2.4, 3.1;
    %     2.0, 4.7, 1.8;
    %     % Add more points as needed
    % ];
    roof_level = find_roof_level(data);
    
    
    [idx, corepoints] = dbscan(data, 0.2, 40);
    numObjects = length(unique(idx)) - 1;
    
    max_room = max(data(idx ~= -1, 1:2))
    min_room = min(data(idx ~= -1, 1:2))
    
    
    
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
    

    % % roof_level = find_roof_level(data);
    % % 
    % % 
    % % X = [min_room(1), min_room(1), max_room(1), max_room(1)];
    % % Y = [min_room(2), max_room(2), max_room(2), min_room(2)];
    % % Z = [floor_level, floor_level, floor_level, floor_level];
    % % 
    % % %patch('XData', X, 'YData', Y, 'ZData', Z);
    % % 
    % % X = [min_room(1), min_room(1), min_room(1), min_room(1)];
    % % Y = [min_room(2), max_room(2), max_room(2), min_room(2)];
    % % Z = [floor_level, floor_level, roof_level, roof_level];
    % % patch('XData', X, 'YData', Y, 'ZData', Z, 'faceColor', 'blue');
    % % 
    % % X = [max_room(1), max_room(1), max_room(1), max_room(1)];
    % % Y = [min_room(2), max_room(2), max_room(2), min_room(2)];
    % % Z = [floor_level, floor_level, roof_level, roof_level];
    % % patch('XData', X, 'YData', Y, 'ZData', Z, 'faceColor', 'blue');
    % % 
    % % X = [min_room(1), max_room(1), max_room(1), min_room(1)];
    % % Y = [max_room(2), max_room(2), max_room(2), max_room(2)];
    % % Z = [floor_level, floor_level, roof_level, roof_level];
    % % patch('XData', X, 'YData', Y, 'ZData', Z, 'faceColor', 'blue');
    % % 
    % % X = [min_room(1), max_room(1), max_room(1), min_room(1)];
    % % Y = [min_room(2), min_room(2), min_room(2), min_room(2)];
    % % Z = [floor_level, floor_level, roof_level, roof_level];
    % % patch('XData', X, 'YData', Y, 'ZData', Z, 'faceColor', 'blue');

    % % % % % % % [list_of_walls_x, list_of_walls_x_neg, list_of_walls_y, list_of_walls_y_neg] = all_walls(data(idx ~= -1, :));
    % % % % % % % for i = 1:size(list_of_walls_x, 1)
    % % % % % % %     X = [list_of_walls_x(i, 1), list_of_walls_x(i, 1), list_of_walls_x(i, 1), list_of_walls_x(i, 1)];
    % % % % % % %     Y = [list_of_walls_x(i, 2), list_of_walls_x(i, 3), list_of_walls_x(i, 3), list_of_walls_x(i, 2)];
    % % % % % % %     Z = [floor_level, floor_level, roof_level, roof_level];
    % % % % % % %     patch('XData', X, 'YData', Y, 'ZData', Z, 'FaceColor','red');
    % % % % % % % 
    % % % % % % % end
    % % % % % % % 
    % % % % % % % for i = 1:size(list_of_walls_y, 1)
    % % % % % % %     Y = [list_of_walls_y(i, 1), list_of_walls_y(i, 1), list_of_walls_y(i, 1), list_of_walls_y(i, 1)];
    % % % % % % %     X = [list_of_walls_y(i, 2), list_of_walls_y(i, 3), list_of_walls_y(i, 3), list_of_walls_y(i, 2)];
    % % % % % % %     Z = [floor_level, floor_level, roof_level, roof_level];
    % % % % % % %     patch('XData', X, 'YData', Y, 'ZData', Z, 'FaceColor','green');
    % % % % % % % 
    % % % % % % % end
    % % % % % % % 
    % % % % % % % for i = 1:size(list_of_walls_x_neg, 1)
    % % % % % % %     X = [list_of_walls_x_neg(i, 1), list_of_walls_x_neg(i, 1), list_of_walls_x_neg(i, 1), list_of_walls_x_neg(i, 1)];
    % % % % % % %     Y = [list_of_walls_x_neg(i, 2), list_of_walls_x_neg(i, 3), list_of_walls_x_neg(i, 3), list_of_walls_x_neg(i, 2)];
    % % % % % % %     Z = [floor_level, floor_level, roof_level, roof_level];
    % % % % % % %     patch('XData', X, 'YData', Y, 'ZData', Z, 'FaceColor','blue');
    % % % % % % % 
    % % % % % % % end
    % % % % % % % 
    % % % % % % % for i = 1:size(list_of_walls_y_neg, 1)
    % % % % % % %     Y = [list_of_walls_y_neg(i, 1), list_of_walls_y_neg(i, 1), list_of_walls_y_neg(i, 1), list_of_walls_y_neg(i, 1)];
    % % % % % % %     X = [list_of_walls_y_neg(i, 2), list_of_walls_y_neg(i, 3), list_of_walls_y_neg(i, 3), list_of_walls_y_neg(i, 2)];
    % % % % % % %     Z = [floor_level, floor_level, roof_level, roof_level];
    % % % % % % %     patch('XData', X, 'YData', Y, 'ZData', Z, 'FaceColor','yellow');
    % % % % % % % 
    % % % % % % % end

    
    % IKKE SLETT DENNE
    for i = 1:size(data, 1)
        if (idx(i) == -1)
            continue
            % plot3(data(i, 1), data(i, 2), data(i, 3), 'r+', 'MarkerSize', 10);
            % hold on;
        else
            if (corepoints(i) == 1)
                plot3(data(i, 1), data(i, 2), data(i, 3), 'b.', 'MarkerSize', 5);
            else
                plot3(data(i, 1), data(i, 2), data(i, 3), 'g.', 'MarkerSize', 5);
            end
            hold on;
        end

        if mod(i, 1000) == 0
            i
        end
    end
    hold off;
end




