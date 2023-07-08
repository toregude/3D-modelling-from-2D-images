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


