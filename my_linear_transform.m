function transformed_img = my_linear_transform(img, alpha, beta)
    % MY_LINEAR_TRANSFORM 对图像应用线性变换。
    %
    % 输入:
    %   img - 输入灰度图像。
    %   alpha - 放大系数。
    %   beta - 偏移量。
    %
    % 输出:
    %   transformed_img - 变换后的图像。

    % 将图像转换为 double 类型以确保精度
    img_double = double(img);

    % 应用线性变换
    transformed_img = alpha * img_double + beta;

    % 裁剪超出 [0, 255] 范围的值
    transformed_img(transformed_img < 0) = 0;
    transformed_img(transformed_img > 255) = 255;

    % 转换回 uint8 类型
    transformed_img = uint8(transformed_img);
end