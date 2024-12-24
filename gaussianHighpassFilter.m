% 定义高斯高通滤波器
function H = gaussianHighpassFilter(M, N, D0)
    [U, V] = meshgrid(0:N-1, 0:M-1);
    U = mod(U, N) - floor(N/2);
    V = mod(V, M) - floor(M/2);
    D = sqrt(U.^2 + V.^2);
    H = 1 - exp(-(D.^2) / (2*(D0^2)));
end