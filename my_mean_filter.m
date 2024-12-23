function filtered_image = my_mean_filter(input_image, kernel_size)
% MY_MEAN_FILTER 自定义实现均值滤波
%   input_image 为输入的图像数据（可以是灰度图或者彩色图等，根据实际需求调整处理逻辑）
%   kernel_size 为滤波器尺寸，格式为[行尺寸 列尺寸]，例如[3 3]表示3x3的滤波器

    % 获取输入图像的尺寸信息
    [image_rows, image_cols, ~] = size(input_image);
    % 计算滤波器半尺寸，用于后续图像边界填充及窗口滑动
    half_kernel_row = floor(kernel_size(1) / 2);
    half_kernel_col = floor(kernel_size(2) / 2);
    
    % 对输入图像进行边界填充，填充方式选择对称填充，以处理图像边缘像素
    padded_image = padarray(input_image, [half_kernel_row half_kernel_col], 'symmetric');
    % 初始化滤波后的图像，尺寸与原图像一致
    filtered_image = zeros(image_rows, image_cols, size(input_image, 3));
    
    % 循环遍历图像的每个像素（针对彩色图像的每个通道分别处理，如果是灰度图可简化外层循环）
    for channel = 1:size(input_image, 3)
        for row = 1:image_rows
            for col = 1:image_cols
                % 提取以当前像素为中心的窗口区域
                window = padded_image(row:row + kernel_size(1) - 1, col:col + kernel_size(2) - 1, channel);
                % 计算窗口内像素的平均值，作为当前像素滤波后的结果
                filtered_image(row, col, channel) = mean(window(:));
            end
        end
    end
end