function filtered_image = my_bilateral_filter(input_image, sigma_d, sigma_r)
% MY_BILATERAL_FILTER 自定义实现双边滤波
%   input_image 为输入的图像数据
%   sigma_d 为空间域标准差，影响空间距离对滤波权重的作用
%   sigma_r 为值域标准差，影响像素值差异对滤波权重的作用

    [image_rows, image_cols, ~] = size(input_image);
    % 根据空间域标准差大致确定边界填充尺寸，实际应用可进一步优化此计算方式
    pad_size = floor(3 * sigma_d);
    padded_image = padarray(input_image, [pad_size pad_size], 'symmetric');
    filtered_image = zeros(image_rows, image_cols, size(input_image, 3));
    
    % 遍历图像像素（及各通道）进行双边滤波操作
    for channel = 1:size(input_image, 3)
        for row = 1:image_rows
            for col = 1:image_cols
                window = padded_image(row:row + 2 * pad_size, col:col + 2 * pad_size, channel);
                center_value = input_image(row, col, channel);
                spatial_weights = zeros(2 * pad_size + 1, 2 * pad_size + 1);
                range_weights = zeros(2 * pad_size + 1, 2 * pad_size + 1);
                combined_weights = zeros(2 * pad_size + 1, 2 * pad_size + 1);
                sum_weights = 0;
                sum_weighted_values = 0;
                
                [x, y] = meshgrid(-pad_size:pad_size, -pad_size:pad_size);
                spatial_weights = exp(-(x.^2 + y.^2) / (2 * sigma_d^2));
                
                % 计算空间权重、值域权重，并结合得到综合权重，进而计算滤波后的像素值
                for i = 1:size(window, 1)
                    for j = 1:size(window, 2)
                        range_weights(i, j) = exp(-(window(i, j) - center_value)^2 / (2 * sigma_r^2));
                        combined_weights(i, j) = spatial_weights(i, j) * range_weights(i, j);
                        sum_weights = sum_weights + combined_weights(i, j);
                        sum_weighted_values = sum_weighted_values + combined_weights(i, j) * window(i, j);
                    end
                end
                filtered_image(row, col, channel) = sum_weighted_values / sum_weights;
            end
        end
    end
end