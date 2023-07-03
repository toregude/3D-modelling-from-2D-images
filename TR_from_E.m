function [T1, T2, R1, R2] = TR_from_E(E)
    [U, S, V] = svd(E, 'econ');
    if det(U) < 0
        U = U*diag([1 1 -1]);
    end

    if det(V) < 0
        V = V*diag([1 1 -1]);
    end

    R_z1 = [0 -1 0; 1 0 0; 0 0 1];
    R_z2 = [0 1 0; -1 0 0; 0 0 1];

    T1 = U(:, 3);
    T2 = -U(:, 3);

    R1 = U*(R_z1')*V';
    R2 = U*(R_z2')*V';

    T1_hat = U*(R_z1')*S*U';
    T2_hat = U*(R_z2')*S*U';

    T1 = [T1_hat(3,2);T1_hat(1,3);T1_hat(2,1);];
    T2 = [T2_hat(3,2);T2_hat(1,3);T2_hat(2,1)];
end