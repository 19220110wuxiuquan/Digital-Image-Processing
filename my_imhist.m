function my_imhist(img)
% MY_IMHIST 自定义实现类似imhist功能的函数，用于计算并绘制灰度直方图
% 输入参数img为灰度图像（二维矩阵形式）

% 灰度级范围，对于常见的8位灰度图像是0到255
grayLevels = 0:255;

% 用于统计每个灰度级像素个数的数组，初始化为全0
histogram = zeros(1, 256);

% 获取图像的尺寸，height表示行数（高度），width表示列数（宽度）
[height, width] = size(img);

% 嵌套循环遍历图像的每一个像素
for row = 1:height
    for col = 1:width
        % 获取当前像素的灰度值，由于Matlab索引从1开始，这里无需额外处理索引偏移
        pixelValue = img(row, col);
        % 对应灰度级的像素个数加1
        histogram(pixelValue + 1) = histogram(pixelValue + 1) + 1;
    end
end

% 绘制直方图，以灰度级为横坐标，对应像素个数为纵坐标
bar(grayLevels, histogram);
% 设置x轴标签
xlabel('灰度值');
% 设置y轴标签
ylabel('像素个数');
% 设置图表标题
title('灰度直方图');
end