
path = '.\delivery_area_dslr_undistorted\delivery_area\dslr_calibration_undistorted\points3D.txt';

global_coordinates = get_global_coordinates_list_test(path);
global_coordinates = global_coordinates';
scatter3(global_coordinates(1,:),global_coordinates(2,:), global_coordinates(3,:))


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