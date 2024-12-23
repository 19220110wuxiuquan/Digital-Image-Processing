function filtered_image = my_median_filter(input_image)
% MY_MEDIAN_FILTER 自定义实现中值滤波
%   input_image 为输入的图像数据

    [image_rows, image_cols, ~] = size(input_image);
    % 这里以3x3滤波器为例，设置边界填充尺寸，可根据实际需求扩展为通用尺寸输入参数
    pad_size = 1;
    padded_image = padarray(input_image, [pad_size pad_size], 'symmetric');
    filtered_image = zeros(image_rows, image_cols, size(input_image, 3));
    
    % 遍历图像像素（及各通道）进行中值滤波
    for channel = 1:size(input_image, 3)
        for row = 1:image_rows
            for col = 1:image_cols
                window = padded_image(row:row + 2 * pad_size, col:col + 2 * pad_size, channel);
                window_vec = window(:);
                sorted_vec = sort(window_vec);
                % 取排序后向量的中间值作为中值滤波结果
                filtered_image(row, col, channel) = sorted_vec(floor(length(sorted_vec) / 2 + 1));
            end
        end
    end
end