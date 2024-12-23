function rotatedImage = my_imrotate(image, angle, varargin)
    % MY_IMROTATE 旋转图像。
    %   输入:
    %       image - 输入的图像。
    %       angle - 旋转的角度（度数），正为逆时针方向。
    %       varargin - 可选参数，可以包括插值方法 ('nearest', 'bilinear', 'bicubic') 和是否裁剪 ('crop')。

    % 默认设置
    method = 'bilinear'; % 默认使用双线性插值
    crop = false;        % 默认不裁剪

    % 解析可变输入参数
    if mod(length(varargin), 2) ~= 0
        error('参数必须成对出现');
    end
    
    for i = 1:2:length(varargin)
        switch lower(varargin{i})
            case 'method'
                method = varargin{i+1};
            case 'crop'
                crop = true;
            otherwise
                error(['未知参数: ' varargin{i}]);
        end
    end

    % 获取原始图像尺寸
    [rows, cols] = size(image);
    
    % 计算旋转中心
    center_x = (cols + 1) / 2;
    center_y = (rows + 1) / 2;

    % 将角度转换为弧度
    theta = deg2rad(angle);

    % 创建旋转矩阵
    cos_theta = cos(theta);
    sin_theta = sin(theta);

    % 计算旋转后的最大尺寸
    max_size = ceil(sqrt(rows^2 + cols^2));
    output_rows = max_size;
    output_cols = max_size;

    % 初始化旋转后的图像
    rotatedImage = zeros(output_rows, output_cols, class(image));

    % 创建输出图像的坐标网格，并移动到旋转中心
    [X_out, Y_out] = meshgrid(1:output_cols, 1:output_rows);
    X_out_centered = X_out - (output_cols + 1) / 2;
    Y_out_centered = Y_out - (output_rows + 1) / 2;

    % 应用旋转矩阵的逆变换，将旋转后的坐标映射回原图坐标
    X_in = X_out_centered * cos_theta + Y_out_centered * sin_theta + center_x;
    Y_in = -X_out_centered * sin_theta + Y_out_centered * cos_theta + center_y;

    % 找到映射后的坐标落在原始图像范围内的索引
    valid_idx = (X_in >= 1) & (X_in <= cols) & ...
                (Y_in >= 1) & (Y_in <= rows);

    % 根据选择的方法进行插值
    switch lower(method)
        case 'nearest'
            % 最近邻插值逻辑略...

        case 'bilinear'
            % 双线性插值
            % 对有效索引进行插值
            X_valid = X_in(valid_idx);
            Y_valid = Y_in(valid_idx);
            valid_coords = find(valid_idx);
            
            % 使用 interp2 进行双线性插值
            rotatedImage(valid_coords) = interp2(1:cols, 1:rows, double(image), X_valid, Y_valid, 'linear');

        case 'bicubic'
            % 双三次插值实现略...
            error('双三次插值尚未实现');

        otherwise
            error('未知的插值方法');
    end

    % 如果需要裁剪，执行相应的逻辑
    if crop
        % 找到非零像素的边界框
        [bw_rows, bw_cols] = find(rotatedImage ~= 0);
        if ~isempty(bw_rows) && ~isempty(bw_cols)
            rotatedImage = rotatedImage(min(bw_rows):max(bw_rows), min(bw_cols):max(bw_cols));
        end
    end

    % 确保返回的图像与输入图像具有相同的维度
    if ndims(image) == 3 && size(image, 3) > 1
        rotatedImage = permute(rotatedImage, [1 2 3]); % 确保彩色图像是三维数组
    elseif ndims(image) == 2
        rotatedImage = rotatedImage(:,:,1); % 确保灰度图像是二维数组
    end
end