function edge_img = my_prewitt_edge_detection(gray_img)
    % 获取输入灰度图像的尺寸
    [height, width] = size(gray_img);
    
    % 初始化用于存储水平和垂直方向卷积结果的矩阵
    gx = zeros(height, width);
    gy = zeros(height, width);
    
    % 定义Prewitt算子卷积核（水平方向和垂直方向）
    prewittKernelX = [-1 -1 -1; 0 0 0; 1 1 1];
    prewittKernelY = [-1 0 1; -1 0 1; -1 0 1];
    
    % 对图像进行边界扩充，以便处理边缘像素（采用复制边界的方式扩充）
    padded_gray_img = padarray(gray_img, [1, 1], 'replicate');
    
    % 循环遍历图像（除去扩充的边界部分），进行卷积操作（水平方向）
    for row = 1:height
        for col = 1:width
            % 对应卷积核与图像像素的相乘累加操作，实现卷积
            gx(row, col) = prewittKernelX(1, 1) * padded_gray_img(row, col) + prewittKernelX(1, 2) * padded_gray_img(row, col + 1) + prewittKernelX(1, 3) * padded_gray_img(row, col + 2) +...
                prewittKernelX(2, 1) * padded_gray_img(row + 1, col) + prewittKernelX(2, 2) * padded_gray_img(row + 1, col + 1) + prewittKernelX(2, 3) * padded_gray_img(row + 1, col + 2) +...
                prewittKernelX(3, 1) * padded_gray_img(row + 2, col) + prewittKernelX(3, 2) * padded_gray_img(row + 2, col + 1) + prewittKernelX(3, 3) * padded_gray_img(row + 2, col + 2);
        end
    end
    
    % 循环遍历图像（除去扩充的边界部分），进行卷积操作（垂直方向）
    for row = 1:height
        for col = 1:width
            % 对应卷积核与图像像素的相乘累加操作，实现卷积
            gy(row, col) = prewittKernelY(1, 1) * padded_gray_img(row, col) + prewittKernelY(1, 2) * padded_gray_img(row, col + 1) + prewittKernelY(1, 3) * padded_gray_img(row, col + 2) +...
                prewittKernelY(2, 1) * padded_gray_img(row + 1, col) + prewittKernelY(2, 2) * padded_gray_img(row + 1, col + 1) + prewittKernelY(2, 3) * padded_gray_img(row + 1, col + 2) +...
                prewittKernelY(3, 1) * padded_gray_img(row + 2, col) + prewittKernelY(3, 2) * padded_gray_img(row + 2, col + 1) + prewittKernelY(3, 3) * padded_gray_img(row + 2, col + 2);
        end
    end
    
    % 计算边缘强度，按照公式sqrt(gx.^2 + gy.^2)
    edge_img = sqrt(gx.^2 + gy.^2);
end