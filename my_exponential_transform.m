function transformed_img = my_exponential_transform(img, gamma)
    % MY_EXPONENTIAL_TRANSFORM 对图像应用指数变换。
    %
    % 输入:
    %   img - 输入灰度图像。
    %   gamma - 指数变换的伽马值。
    %
    % 输出:
    %   transformed_img - 变换后的图像。

    % 将图像转换为 double 类型以确保精度，并归一化到 [0, 1] 范围
    img_normalized = double(img) / 255;

    % 应用指数变换
    transformed_img = 255 * (img_normalized .^ gamma);

    % 转换回 uint8 类型
    transformed_img = uint8(transformed_img);
end