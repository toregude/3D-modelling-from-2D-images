

% Hva som må gjøres i GUI
% legge inn en fil med bildene
% eksempel kicker_dslr_...
% denne konkattineres med \camera.txt filen
% Finnes det en måte å hente ut dette direkte dersom vi ikke vet navnet
% allerede?
% Vi har i alle fall kamera.txt, så denne vil funke




function [K] = K_from_cameraparams(path)

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

