function [T, R, lambda, P1, camC1, camC2] = reconstruction(T1, T2, R1, R2, correspondences, K)
    % Preparation
    N = length(correspondences(1, :));
    T_cell = {T1, T2, T1, T2};
    R_cell = {R1, R1, R2, R2};
    x1 = correspondences(1:2, :);
    x2 = correspondences(3:4, :);
    x1(3, :) = 1;
    x2(3, :) = 1;
    for i = 1:N
        Kx1 = K^-1*x1(:, i);
        Kx2 = K^-1*x2(:, i);
        x1(:, i) = Kx1;
        x2(:, i) = Kx2;
    end
    d = zeros(N, 2);
    d_cell = {d, d, d, d};

    % Reconstruction
    n = size(T_cell, 2);
    N = size(correspondences, 2);
    M1 = zeros(3*N, N + 1);
    M2 = zeros(3*N, N + 1);
    maxSum = 0;
    maxIdx = 1;
    for i = 1:n
        T = T_cell{i};
        R = R_cell{i};
        for j = 1:N
            x2hat = [0 -x2(3, j) x2(2, j); x2(3, j) 0 -x2(1, j); -x2(2, j) x2(1, j) 0];
            x1hat = [0 -x1(3, j) x1(2, j); x1(3, j) 0 -x1(1, j); -x1(2, j) x1(1, j) 0];
            M1((3*j - 2):(3*j), end) = x2hat*T;
            M1((3*j - 2):(3*j), j)   = x2hat*R*x1(:, j);
            M2((3*j - 2):(3*j), end) = -x1hat*R'*T;
            M2((3*j - 2):(3*j), j)   = x1hat*R'*x2(:, j);
        end
        [U1, S1, V1] = svd(M1);
        [U2, S2, V2] = svd(M2);
        d1 = V1(:, end);
        d2 = V2(:, end);
        d1 = d1 / d1(end);
        d2 = d2 / d2(end);
        d_tot = [d1, d2];
        d_cell{i} = d_tot(1:end-1, :);
        max = sum(sign(d_cell{i}));
        if max(1) > maxSum
            maxSum = max;
            maxIdx = i;
        end
    end
    R = R_cell{maxIdx};
    T = T_cell{maxIdx};
    lambda = d_cell{maxIdx};

    % Calculation and visualization of the 3D points and the cameras

    P1 = zeros(3, size(x1, 2));
    for i = 1:size(x1, 2)
        P1(:, i) = x1(:, i)*lambda(i);
    end
    figure;
    scatter3(P1(1, :), P1(2, :), P1(3, :));
    camC1 = [-0.2 0.2 0.2 -0.2; 0.2 0.2 -0.2 -0.2; 1 1 1 1];
    camC2 = zeros(3, 4);
    for i = 1:4
        camC2(:, i) = R\(camC1(:, i) - T);
    end
    hold on
    for i = 1:size(P1, 2)
        text(P1(1, i), P1(2, i), P1(3, i), sprintf('%d', i));
    end
    plot3(camC1(1, :), camC1(2, :), camC1(3, :), 'Color', 'b');
    plot3(camC2(1, :), camC2(2, :), camC2(3, :), 'Color', 'r');
    campos([43, -22, -87]);
    camup([-0.0906, -0.9776, 0.1899]);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    grid on;
end