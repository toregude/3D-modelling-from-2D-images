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
