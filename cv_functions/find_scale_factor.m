function scale_factor = find_scale_factor(cam_pos_sorted, sequence)
    campos_indices = cam_pos_sorted(sequence,:);
    campos_seq = campos_indices(:,2:4);
    scale_factor = zeros(size(campos_seq,1)-1,1);
    for i = 1:size(campos_seq,1)-1
        scale_factor(i) = (abs(campos_seq(i)-campos_seq(i+1)));
    end
end