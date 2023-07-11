function [origin, sideLengths, floor_walls] =  create_3D_model(points_3D_array)

    %Input points is in coordinate system xzy, transform to xyz
    y_temp = points_3D_array(:,3);
    z_temp = points_3D_array(:,2);
    points_3D_array(:,2:3) = [y_temp, z_temp];
    
    %Find the height of the room by checking where the first clusters are located in z-direction
    floor_level = find_floor_level(points_3D_array);
    roof_level = find_roof_level(points_3D_array) - floor_level;
    points_3D_array(:,3) = points_3D_array(:,3) - floor_level;
    floor_level = 0;

    %Clustering by dbscan-method
    [idx, ~] = dbscan(points_3D_array, 0.10, 15);
    num_objects = length(unique(idx)) - 1;
    
    %Find highest and smallest x and y coordinates for the points that are
    %not outliers to sketch a floor and walls
    max_room = max(points_3D_array(idx ~= -1, 1:2));
    min_room = min(points_3D_array(idx ~= -1, 1:2));
    
    %Creating two lists where the minimum and maximum values of the clusters are to be located.
    min_list = zeros(3,num_objects)';
    max_list = zeros(3,num_objects)';
    for i = 1:num_objects
        points_i = points_3D_array(idx==i, :);
        max_list(i, :) = max(points_i);
        min_list(i, :) = min(points_i);
    end
    
    %Finding origin and sideLength of each cluster based on minimum and maximum x and y values.
    origin = zeros(num_objects, 3);
    sideLengths = zeros(num_objects, 3);
    for i = 1:num_objects
        O = (min_list(i, :) + max_list(i, :))/2;
        len_X = max_list(i, 1) - min_list(i, 1);
        len_Y = max_list(i, 2) - min_list(i, 2);
        len_Z = max_list(i, 3) - min_list(i, 3);
        lengths = [len_X, len_Y, len_Z];
        origin(i, :) = O;
        sideLengths(i ,:) = lengths;
    end
    
    %Creating floor and walls
    floor_walls = cell(1,5);
    X_floor = [min_room(1), min_room(1), max_room(1), max_room(1)];
    Y_floor = [min_room(2), max_room(2), max_room(2), min_room(2)];
    Z_floor = [floor_level, floor_level, floor_level, floor_level];
    floor_walls{1} = [X_floor; Y_floor; Z_floor];

    X_1 = [min_room(1), min_room(1), min_room(1), min_room(1)];
    Y_1 = [min_room(2), max_room(2), max_room(2), min_room(2)];
    Z_1 = [floor_level, floor_level, roof_level, roof_level];
    floor_walls{2} = [X_1; Y_1; Z_1];

    X_2 = [max_room(1), max_room(1), max_room(1), max_room(1)];
    Y_2 = [min_room(2), max_room(2), max_room(2), min_room(2)];
    Z_2 = [floor_level, floor_level, roof_level, roof_level];
    floor_walls{3} = [X_2; Y_2; Z_2];

    X_3 = [min_room(1), max_room(1), max_room(1), min_room(1)];
    Y_3 = [max_room(2), max_room(2), max_room(2), max_room(2)];
    Z_3 = [floor_level, floor_level, roof_level, roof_level];
    floor_walls{4} = [X_3; Y_3; Z_3];

    X_4 = [min_room(1), max_room(1), max_room(1), min_room(1)];
    Y_4 = [min_room(2), min_room(2), min_room(2), min_room(2)];
    Z_4 = [floor_level, floor_level, roof_level, roof_level];
    floor_walls{5} = [X_4; Y_4; Z_4];
end