function [transformed_points] = transform_points(sequence_start_frame_index, sequence_end_frame_index, points, relPose_cell)
    %It is important that each point in points is a row vector
    %sequence_start_frame_index, sequence_end_frame_index is sequence(i)
    %for the start and end
    
    transformed_points = points;
    for i = sequence_start_frame_index:(sequence_end_frame_index-2)
        disp(relPose_cell{i});
        transformed_points = transformPointsForward(relPose_cell{i}, transformed_points);
    end

end