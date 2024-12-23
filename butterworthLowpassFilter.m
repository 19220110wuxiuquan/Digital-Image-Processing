function H = butterworthLowpassFilter(M, N, cutoffFreq, n)
% BUTTERWORTHLOWPASSFILTER 生成巴特沃斯低通滤波器的传递函数
%   M, N 分别为图像频谱的行数和列数
%   cutoffFreq 为截止频率
%   n 为滤波器阶数
    [U, V] = meshgrid(-fix(N/2):ceil(N/2)-1, -fix(M/2):ceil(M/2)-1);
    D = sqrt(U.^2 + V.^2);
    H = 1./ (1 + (D / cutoffFreq).^(2*n));
end