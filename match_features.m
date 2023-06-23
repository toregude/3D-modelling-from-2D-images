

I1 = im2gray(imread("DSC_0682.JPG"));
cameraParams = cameraParameters;
I2 = im2gray(imread("DSC_0684.JPG"));

K = [3408.59 0 3117.24; 0 3408.87 2064.07; 0 0 1];

points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

[features1,valid_points1] = extractFeatures(I1,points1);
[features2,valid_points2] = extractFeatures(I2,points2);

indexPairs = matchFeatures(features1,features2);

matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);




[E,inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2,Method="RANSAC", NumTrials=2000,DistanceThreshold=1e-3);

matchedPoints1_inliers = matchedPoints1(inliers==1);
matchedPoints2_inliers = matchedPoints2(inliers==1);
correspondences = [matchedPoints1_inliers.Location, matchedPoints2_inliers.Location];
figure; 
showMatchedFeatures(I1,I2,matchedPoints1_inliers,matchedPoints2_inliers);
correspondences'

[T1, T2, R1, R2, U, V] = TR_from_E(E);
[T, R, lambda, P1, camC1, camC2] = reconstruction(T1, T2, R1, R2, correspondences', K)

%%  Functions

function [T1, T2, R1, R2, U, V] = TR_from_E(E)
    [U, S, V] = svd(E, 'econ')
    if det(U) < 0
        U = U*diag([1 1 -1]);
    end
    if det(V) < 0
        V = V*diag([1 1 -1]);
    end
    T1 = U(:, 3);
    T2 = -U(:, 3);
    R1 = U*[0 1 0; -1 0 0; 0 0 1]*V';
    R2 = U*[0 -1 0; 1 0 0; 0 0 1]*V';
end
% function [T1,R1,T2,R2, U, V]=TR_from_E(E)
% 
% % Stelle sicher, dass U und V Rotationsmatrizen sind
% [U,S,V]=svd(E);
% 
% if det(U) < 0
% 	U = U*diag([1 1 -1]);
% end
% 
% if det(V) < 0
% 	V = V*diag([1 1 -1]);
% end
% 
% % Der Vektor T liegt im Nullraum von E', ebenso liegt U(:,3) im Nullraum
% % von E'. Da die Translation nur bis auf Skalierung geschätzt werden kann,
% % können wir diesen Vektor für T verwenden.
% % T1=U(:,3); 
% 
% % T2 zeigt in die entgegengesetzte Richtung
% % T2=-T1;
% 
% RZp=[0 -1 0; 1 0 0;0 0 1];
% RZm=[0  1 0;-1 0 0;0 0 1];
% 
% R1=U*RZp'*V';
% R2=U*RZm'*V';
% 
% % Alternativ laesst sich T ueber die Formel aus dem Skript berechnen
% T1_hat = U*RZp*S*U';
% T1 = [T1_hat(3,2);T1_hat(1,3);T1_hat(2,1);];
% T2_hat = U*RZm*S*U';
% T2 = [T2_hat(3,2);T2_hat(1,3);T2_hat(2,1)];
% 
% end



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

