function get_global_coordinates_list(points3D_all)
    
    % path = '.\delivery_area_dslr_undistorted (ONLY FOR DEBUGGING)\delivery_area\dslr_calibration_undistorted\points3D.txt';
    
    %global_coordinates = get_global_coordinates_list_test(path);
    global_coordinates = points3D_all; %Bare for å teste med våre koordinater
    % Må kjøre toreTry3Dcordinates.m først
    %scatter3(global_coordinates(1,:),global_coordinates(2,:), global_coordinates(3,:))
    
    % Create a sample point cloud data in a list format
    data = global_coordinates;
    
    floor_level = find_floor_level(data)
    % [
    %     1.2, 3.4, 2.1;
    %     2.3, 1.5, 4.2;
    %     5.6, 2.4, 3.1;
    %     2.0, 4.7, 1.8;
    %     % Add more points as needed
    % ];
    
    
    
    [idx, corepoints] = dbscan(data, 0.1, 15);
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
        drawBox(senterliste(i,:), lengdeliste(i,:));
    end
    
    X = [min_room(1), min_room(1), max_room(1), max_room(1)];
    Y = [min_room(2), max_room(2), max_room(2), min_room(2)];
    Z = [floor_level, floor_level, floor_level, floor_level];
    
    
    patch('XData', X, 'YData', Y, 'ZData', Z);
    
    
    
    
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




