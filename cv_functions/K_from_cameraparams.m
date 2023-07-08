function [K] = K_from_cameraparams(path)
    path = fullfile(path, '\cameras.txt');
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

    fx = str2double(elems{5});
    fy = str2double(elems{6});
    cx = str2double(elems{7});
    cy = str2double(elems{8});

    K = [fx 0 cx; 0 fy cy; 0 0 1];
    fclose(fid);
end

