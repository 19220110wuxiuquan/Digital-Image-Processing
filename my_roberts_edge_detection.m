function edge_img = my_roberts_edge_detection(gray_img)
    % 获取输入灰度图像的尺寸
    [height, width] = size(gray_img);
    
    % 初始化用于存储水平和垂直方向卷积结果的矩阵
    g1 = zeros(height, width);
    g2 = zeros(height, width);
    
    % 定义Roberts算子卷积核（水平方向和垂直方向）
    robertsKernelX = [-1 0; 0 1];
    robertsKernelY = [0 -1; 1 0];
    
    % 对图像进行边界扩充，以便处理边缘像素（采用复制边界的方式扩充）
    padded_gray_img = padarray(gray_img, [1, 1], 'replicate');
    
    % 循环遍历图像（除去扩充的边界部分），进行卷积操作（水平方向）
    for row = 1:height
        for col = 1:width
            % 对应卷积核与图像像素的相乘累加操作，实现卷积
            g1(row, col) = robertsKernelX(1, 1) * padded_gray_img(row, col) + robertsKernelX(1, 2) * padded_gray_img(row, col + 1) +...
                robertsKernelX(2, 1) * padded_gray_img(row + 1, col) + robertsKernelX(2, 2) * padded_gray_img(row + 1, col + 1);
        end
    end
    
    % 循环遍历图像（除去扩充的边界部分），进行卷积操作（垂直方向）
    for row = 1:height
        for col = 1:width
            % 对应卷积核与图像像素的相乘累加操作，实现卷积
            g2(row, col) = robertsKernelY(1, 1) * padded_gray_img(row, col) + robertsKernelY(1, 2) * padded_gray_img(row, col + 1) +...
                robertsKernelY(2, 1) * padded_gray_img(row + 1, col) + robertsKernelY(2, 2) * padded_gray_img(row + 1, col + 1);
        end
    end
    
    % 计算边缘强度，按照公式sqrt(g1.^2 + g2.^2)
    edge_img = sqrt(g1.^2 + g2.^2);
end