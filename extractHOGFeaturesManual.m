function hog_features = extractHOGFeaturesManual(img)
    [h, w] = size(img);
     % 确保图像为 double 类型并归一化到 [0, 1]
    img = im2double(img); % 将图像转换为 double 类型
    img = sqrt(img); % 伽马校正

    fy = [-1 0 1]; % 定义竖直模板
    fx = fy'; % 定义水平模板
    Iy = imfilter(img, fy, 'replicate'); % 竖直边缘
    Ix = imfilter(img, fx, 'replicate'); % 水平边缘
    Ied = sqrt(Ix.^2 + Iy.^2); % 边缘强度
    Iphase = Iy ./ Ix;

    step = 16; % step*step个像素作为一个单元
    orient = 9; % 方向直方图的方向个数
    jiao = 360 / orient; % 每个方向包含的角度数
    Cell = cell(1, 1);
    ii = 1;
    jj = 1;
    for i = 1:step:h - step + 1
        ii = 1;
        for j = 1:step:w - step + 1
            tmpx = Ix(i:i + step - 1, j:j + step - 1);
            tmped = Ied(i:i + step - 1, j:j + step - 1);
            tmped = tmped / sum(sum(tmped)); % 局部边缘强度归一化
            tmpphase = Iphase(i:i + step - 1, j:j + step - 1);
            Hist = zeros(1, orient);
            for p = 1:step
                for q = 1:step
                    if isnan(tmpphase(p, q)) % 0/0会得到nan，如果像素是nan，重设为0
                        tmpphase(p, q) = 0;
                    end
                    ang = atan(tmpphase(p, q));
                    ang = mod(ang * 180 / pi, 360); % 全部变正，-90变270
                    if tmpx(p, q) < 0
                        if ang < 90 % 如果是第一象限
                            ang = ang + 180; % 移到第三象限
                        end
                        if ang > 270 % 如果是第四象限
                            ang = ang - 180; % 移到第二象限
                        end
                    end
                    ang = ang + 0.0000001;
                    Hist(ceil(ang / jiao)) = Hist(ceil(ang / jiao)) + tmped(p, q); % 使用边缘强度加权
                end
            end
            Hist = Hist / sum(Hist); % 方向直方图归一化
            Cell{ii, jj} = Hist;
            ii = ii + 1;
        end
        jj = jj + 1;
    end

    [m, n] = size(Cell);
    feature = cell(1, (m - 1) * (n - 1));
    for i = 1:m - 1
        for j = 1:n - 1
            f = [];
            f = [f Cell{i, j}(:)' Cell{i, j + 1}(:)' Cell{i + 1, j}(:)' Cell{i + 1, j + 1}(:)'];
            feature{(i - 1) * (n - 1) + j} = f;
        end
    end

    l = length(feature);
    hog_features = [];
    for i = 1:l
        hog_features = [hog_features; feature{i}(:)'];
    end