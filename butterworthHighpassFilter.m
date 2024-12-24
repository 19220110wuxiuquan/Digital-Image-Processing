% 定义巴特沃斯高通滤波器
function H = butterworthHighpassFilter(M, N, D0, n)
    [U, V] = meshgrid(0:N-1, 0:M-1);
    U = mod(U, N) - floor(N/2);
    V = mod(V, M) - floor(M/2);
    D = sqrt(U.^2 + V.^2);
    H = 1 ./ (1 + (D0 ./ (D + eps)).^(2*n));
end