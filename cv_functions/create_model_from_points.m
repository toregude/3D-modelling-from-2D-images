function [origin, sideLengths, floor_walls] =  create_model_from_points(data)
    %we take in a dataset in a xzy-coordinate system. Must therefore change
    %the columns 2 and 3 to get a xyz-coordinate system
    ytemp = data(:,3);
    ztemp = data(:,2);
    data(:,2:3) = [ytemp, ztemp];
    
    floor_level = find_floor_level(data);
    roof_level = find_roof_level(data)- floor_level;
    data(:,3) = data(:,3) -floor_level;
    floor_level = 0;
    % Må legge inn en formel som avgjør parameter 2 og 3 i dbscan.
    %Creating pointcloud
    [idx, corepoints] = dbscan(data, 0.2, 40);
    numObjects = length(unique(idx)) - 1;
    
    %Find highest and smallest x and y coordinates for the points that are
    %not outliers to sketch a floor and walls
    max_room = max(data(idx ~= -1, 1:2))
    min_room = min(data(idx ~= -1, 1:2))
    
    
    
    min_list = zeros(3,numObjects)';
    max_list = zeros(3,numObjects)';
    for i = 1:numObjects
        points_i = data(idx==i, :);
        max_list(i, :) = max(points_i);
        min_list(i, :) = min(points_i);
    end
    
    origin = zeros(numObjects, 3);
    sideLengths = zeros(numObjects, 3);
    for i = 1:numObjects
        O = (min_list(i, :) + max_list(i, :))/2;
        lenX = max_list(i, 1) - min_list(i, 1);
        lenY = max_list(i, 2) - min_list(i, 2);
        lenZ = max_list(i, 3) - min_list(i, 3);
        lengder = [lenX, lenY, lenZ];
        origin(i, :) = O;
        sideLengths(i ,:) = lengder;
    end
    
    %creating floor and walls
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

