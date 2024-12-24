function value = bilinear_interpolation(img, x, y)
    % 获取图像尺寸
    [m, n] = size(img);
    
    % 向上取整和向下取整
    x1 = floor(x); % 向下
    x2 = ceil(x);  % 向上
    y1 = floor(y);
    y2 = ceil(y);
    
    % 确保不超出图像边界
    x1 = max(1, min(x1, n-1));
    x2 = max(1, min(x2, n));
    y1 = max(1, min(y1, m-1));
    y2 = max(1, min(y2, m));
    
    % 如果点位于图像边界，则直接返回该点的值
    if x1 == x2 && y1 == y2
        value = img(y1, x1);
        return;
    end
    
    % 获取四个邻近点的值
    Q11 = img(y1, x1);
    Q21 = img(y2, x1);
    Q12 = img(y1, x2);
    Q22 = img(y2, x2);
    
    % 计算权重
    wx = x - x1;
    wy = y - y1;
    
    % 应用双线性插值公式
    value = (Q11 * (x2-x) * (y2-y) + ...
             Q21 * (x-x1) * (y2-y) + ...
             Q12 * (x2-x) * (y-y1) + ...
             Q22 * (x-x1) * (y-y1));
end