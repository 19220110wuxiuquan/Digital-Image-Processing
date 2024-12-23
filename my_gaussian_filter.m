function filtered_image = my_gaussian_filter(input_image, kernel_size, sigma)
% MY_GAUSSIAN_FILTER 自定义实现高斯滤波
%   input_image 为输入的图像数据
%   kernel_size 为滤波器尺寸，例如[3 3]
%   sigma 为高斯分布的标准差，控制滤波的平滑程度

    [image_rows, image_cols, ~] = size(input_image);
    half_kernel_row = floor(kernel_size(1) / 2);
    half_kernel_col = floor(kernel_size(2) / 2);
    
    padded_image = padarray(input_image, [half_kernel_row half_kernel_col], 'symmetric');
    filtered_image = zeros(image_rows, image_cols, size(input_image, 3));
    
    % 生成二维高斯核
    [x, y] = meshgrid(-half_kernel_col:half_kernel_col, -half_kernel_row:half_kernel_row);
    gaussian_kernel = exp(-(x.^2 + y.^2) / (2 * sigma^2));
    gaussian_kernel = gaussian_kernel / sum(gaussian_kernel(:));
    
    % 针对每个像素（及彩色图像的每个通道）进行滤波操作
    for channel = 1:size(input_image, 3)
        for row = 1:image_rows
            for col = 1:image_cols
                window = padded_image(row:row + kernel_size(1) - 1, col:col + kernel_size(2) - 1, channel);
                % 将窗口内像素与高斯核进行加权求和，得到滤波后的像素值
                filtered_image(row, col, channel) = sum(sum(window.* gaussian_kernel));
            end
        end
    end
end