function H = idealLowpassFilter(M, N, cutoffFreq)
% IDEALLOWPASSFILTER 生成理想低通滤波器的传递函数
%   M, N 分别为图像频谱的行数和列数
%   cutoffFreq 为截止频率
    [U, V] = meshgrid(-fix(N/2):ceil(N/2)-1, -fix(M/2):ceil(M/2)-1);
    D = sqrt(U.^2 + V.^2);
    H = double(D <= cutoffFreq);
end