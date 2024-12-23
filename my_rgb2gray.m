function grayImage = my_rgb2gray(rgbImage)
    % CUSTOM_RGB2GRAY 将RGB图像转换为灰度图像。
    %   输入:
    %       rgbImage - 输入的RGB图像，尺寸为MxNx3。
    %   输出:
    %       grayImage - 输出的灰度图像，尺寸为MxN。

    % 确保输入是一个三维数组
    if size(rgbImage, 3) ~= 3
        error('输入图像必须是RGB格式');
    end

    % 定义RGB到灰度的转换系数
    weights = [0.2989, 0.5870, 0.1140];

    % 将RGB图像的每个通道乘以其对应的权重，然后相加得到灰度图像
    grayImage = rgbImage(:,:,1) * weights(1) + ...
                rgbImage(:,:,2) * weights(2) + ...
                rgbImage(:,:,3) * weights(3);

    % 确保输出数据类型与输入一致
    grayImage = uint8(grayImage);
end