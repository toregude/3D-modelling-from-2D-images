function [origin, sideLength, X_floor, Y_floor, Z_floor] = get_boxes()
    path = '.\delivery_area_dslr_undistorted (ONLY FOR DEBUGGING)\delivery_area\dslr_calibration_undistorted\points3D.txt';
    global_coordinates = get_global_coordinates_list_test(path);%THIS SHOULD BE ACTUAL POINTCLOUD
    data = global_coordinates;
    floor_level = find_floor_level(data);
    
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

    origin = zeros(numObjects, 3);
    sideLength = zeros(numObjects, 3);
    for i = 1:numObjects
        O = (min_list(i, :) + max_list(i, :))/2;
        lenX = max_list(i, 1) - min_list(i, 1);
        lenY = max_list(i, 2) - min_list(i, 2);
        lenZ = max_list(i, 3) - min_list(i, 3);
        lengder = [lenX, lenY, lenZ];
        origin(i, :) = O;
        sideLength(i ,:) = lengder;
    end
    
    X_floor = [min_room(1), min_room(1), max_room(1), max_room(1)];
    Y_floor = [min_room(2), max_room(2), max_room(2), min_room(2)];
    Z_floor = [floor_level, floor_level, floor_level, floor_level];

end

function floor_level = find_floor_level(data)
    minimum_floor = -10.;
    maximum_floor = 10.;
    delta_z = 0.05;
    z = minimum_floor:delta_z:maximum_floor;
    last_count = 0;
    floor_level = minimum_floor;
    for i = 1:(length(z)-1)
        count = length(data(data(:, 3) < z(i+1))) - length(data(data(:, 3) <= z(i)));
        if count < 30
            last_count = count;
            continue;
        else
            if count/last_count > 10
                floor_level = z(i);
                break;
            end
        end
    end
end

function no_lines = count_lines(path)
    lineNumber = 0;
    lastElementLine = 0;
    fid = fopen(path);
    % Read the file line by line until the end
    while ~feof(fid)
        lineNumber = lineNumber + 1;
        line = fgetl(fid);
        if ~isempty(line)
            lastElementLine = lineNumber;
        end
    end

    fclose(fid);

    no_lines = lastElementLine;
end

function global_coordinates = get_global_coordinates_list_test(path)
    no_lines = count_lines(path);
    no_coords = no_lines - 3;

    fid = fopen(path);
    tline = fgets(fid);
    while ischar(tline)
        elems = strsplit(tline);
        if numel(elems) < 4 || strcmp(elems(1), '#')
            tline = fgets(fid);
            continue
        else
            break;
        end 
    end

    global_coordinates = zeros(no_coords, 3);
    
    i = 1;
    while ischar(tline)
        elems = strsplit(tline);
        X = str2double(elems{2});
        Y = str2double(elems{3});
        Z = str2double(elems{4});
        tline = fgets(fid);
        global_coordinates(i, 1) = X;
        global_coordinates(i, 2) = Y;
        global_coordinates(i, 3) = Z;
        i = i + 1;
    end

    fclose(fid);
end