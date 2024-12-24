% 定义理想高通滤波器
function H = idealHighpassFilter(M, N, D0)
    [U, V] = meshgrid(0:N-1, 0:M-1);
    U = mod(U, N) - floor(N/2);
    V = mod(V, M) - floor(M/2);
    D = sqrt(U.^2 + V.^2);
    H = double(D >= D0);
end