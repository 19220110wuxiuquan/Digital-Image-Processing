function transformed_img = my_log_transform(img)
    % MY_LOG_TRANSFORM 对图像应用对数变换。
    %
    % 输入:
    %   img - 输入灰度图像。
    %
    % 输出:
    %   transformed_img - 变换后的图像。

    % 将图像转换为 double 类型以确保精度
    img_double = double(img);

    % 计算对数变换常数 c
    c = 255 / log(1 + max(img_double(:)));

    % 应用对数变换
    transformed_img = c * log(1 + img_double);

    % 转换回 uint8 类型
    transformed_img = uint8(transformed_img);
end