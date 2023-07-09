function [data] = get_global_R_and_T()

    % Specify the path to your .txt file
    file_path = '.\kicker_dslr_undistorted\kicker\dslr_calibration_undistorted\images.txt';
    
    % Open the file
    fid = fopen(file_path, 'r');
    
    % Initialize arrays to store the parameters
    data = [];
    
    % Read each line of the file
    tline = fgetl(fid);
    while ischar(tline)
        % Check if the line contains useful information
        if contains(tline, 'dslr_images_undistorted')
            % Extract the parameters between the first integer and 0
            values = sscanf(tline, '%*d %f %f %f %f %f %f %f %*d %*s');
            
            % Append the extracted parameters to the data array
            data = [data; values'];
        end
        
        % Read the next line
        tline = fgetl(fid);
    end
    
    % Close the file
    fclose(fid);
    
    % Display the extracted parameters
    % disp(data);
end