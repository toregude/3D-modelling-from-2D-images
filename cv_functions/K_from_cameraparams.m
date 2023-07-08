function [K] = K_from_cameraparams(camerastxt)
    fx = camerastxt(3,5);
    fy = camerastxt(3,6);
    cx = camerastxt(3,7);
    cy = camerastxt(3,8);

    K = [fx 0 cx; 0 fy cy; 0 0 1];
end

