function [K] = estimate_K(imageSize, k)
    %k is usually chosen in the interval [0.5, 2]

    D_x = imageSize(1);
    D_y = imageSize(2);

    f = k*D_x;

    K = [f 0 D_x/2; 0 f D_y/2; 0 0 1];

end