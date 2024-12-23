function lbp_img = computeLBPImage(gray_img)
    % 默认参数：半径为1，邻居点数为8（3x3邻域）
    radius = 1;
    neighbors = 8;

    % 获取图像尺寸
    [rows, cols] = size(gray_img);

    % 初始化LBP图像，填充NaN以处理边界情况
    lbp_img = NaN(rows, cols);

    % 遍历图像中的每个像素（除了边界）
    for i = radius + 1:rows - radius
        for j = radius + 1:cols - radius
            centerPixel = gray_img(i, j);
            code = 0;
            for n = 0:(neighbors-1)
                % 计算邻居的位置
                theta = 2 * pi / neighbors * n;
                x = i + round(radius * cos(theta));
                y = j - round(radius * sin(theta));

                % 比较中心像素与邻居像素
                if gray_img(x, y) >= centerPixel
                    code = bitset(code, neighbors - n);
                end
            end
            lbp_img(i, j) = code;
        end
    end

    % 处理边界（可选），这里简单地用0填充
    lbp_img(isnan(lbp_img)) = 0;