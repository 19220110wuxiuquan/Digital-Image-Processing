function matched_image = my_histmatch(input_image, target_image)
    % 检查输入图像是否为灰度图，若不是则尝试转换为灰度图（若转换失败则报错）
    if size(input_image, 3) > 1
        input_image = rgb2gray(input_image);
        if isempty(input_image)
            error('无法将输入的原始彩色图像转换为灰度图像，请检查图像数据');
        end
    end
    if size(target_image, 3) > 1
        target_image = rgb2gray(target_image);
        if isempty(target_image)
            error('无法将输入的目标彩色图像转换为灰度图像，请检查图像数据');
        end
    end
    
    % 获取输入图像尺寸，并检查尺寸合法性，避免后续出现越界访问
    [input_height, input_width] = size(input_image);
    [target_height, target_width] = size(target_image);
    if input_height <= 0 || input_width <= 0 || target_height <= 0 || target_width <= 0
        error('输入的图像尺寸不合法，请检查图像数据');
    end
    
    % 若目标图像与原始图像尺寸不一致，进行等比例缩放使其尺寸适配（这里采用简单的双线性插值缩放方法）
    % 实际应用中可根据具体需求选择更合适的缩放算法或进行更复杂的图像预处理
    if input_height ~= target_height || input_width ~= target_width
        input_image = imresize(input_image, [target_height, target_width], 'bilinear');
        [input_height, input_width] = size(input_image);
    end
    
    % 步骤一：计算原始图像的直方图和累计分布函数（CDF）
    input_hist = zeros(1, 256); % 初始化原始图像直方图数组
    for row = 1:input_height
        for col = 1:input_width
            pixel_value = input_image(row, col) + 1; % Matlab索引从1开始，灰度值范围0-255需加1对应索引
            input_hist(pixel_value) = input_hist(pixel_value) + 1;
        end
    end
    input_hist = input_hist / (input_height * input_width); % 归一化直方图，得到概率分布
    input_cdf = cumsum(input_hist); % 计算原始图像累计分布函数
    
    % 步骤二：计算目标图像的直方图和累计分布函数（CDF）
    target_hist = zeros(1, 256); % 初始化目标图像直方图数组
    for row = 1:target_height
        for col = 1:target_width
            pixel_value = target_image(row, col) + 1;
            target_hist(pixel_value) = target_hist(pixel_value) + 1;
        end
    end
    target_hist = target_hist / (target_height * target_width); % 归一化直方图
    target_cdf = cumsum(target_hist); % 计算目标图像累计分布函数
    
    % 步骤三：建立映射关系
    mapping = zeros(1, 256); % 用于存储从原始图像灰度值到目标图像灰度值的映射
    for i = 1:256
        % 找到目标图像CDF中与原始图像当前灰度级的CDF值最接近的位置
        [~, idx] = min(abs(target_cdf - input_cdf(i)));
        mapping(i) = idx - 1; % 由于Matlab索引从1开始，这里要减去1得到实际灰度值（0-255范围）
    end
    
    % 步骤四：根据映射关系生成匹配后的图像
    matched_image = zeros(size(input_image), class(input_image)); % 初始化匹配后的图像
    for row = 1:input_height
        for col = 1:input_width
            pixel_value = input_image(row, col) + 1;
            matched_image(row, col) = mapping(pixel_value);
        end
    end
    matched_image = uint8(matched_image); % 将匹配后的图像转换为合适的无符号8位整数类型（常见灰度图像类型）
end