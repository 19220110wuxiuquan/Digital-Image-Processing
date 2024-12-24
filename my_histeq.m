function eq_gray_img = my_histeq(gray_img)
    % 获取图像尺寸和灰度级别
    [rows, cols] = size(gray_img);
    levels = 256; % 对于8位图像
    
    % 计算直方图
    hist = imhist(gray_img);
    
    % 计算累积分布函数 (CDF)
    cdf = cumsum(hist);
    
    % 线性化 CDF 到 [0, levels-1]
    cdf_min = min(cdf(cdf > 0)); % 找到第一个非零值
    cdf_normalized = round((cdf - cdf_min) / (rows * cols - cdf_min) * (levels - 1));
    
    % 创建查找表 (LUT) 并应用到图像
    lut = uint8(1:levels);
    lut(:) = cdf_normalized + 1;
    eq_gray_img = lut(double(gray_img) + 1);
    
    % 转换回uint8类型
    eq_gray_img = uint8(eq_gray_img);
end