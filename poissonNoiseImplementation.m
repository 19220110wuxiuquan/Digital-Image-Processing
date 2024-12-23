function noisyImage = poissonNoiseImplementation(image)
    [height, width] = size(image);
    noisyImage = zeros(size(image));
    % 对于每个像素，根据其灰度值按照泊松分布生成噪声
    for y = 1:height
        for x = 1:width
            lambda = image(y, x);
            % 使用内置的泊松分布随机数生成函数，这里考虑了像素值不能为负的情况
            if lambda > 0
                noisyImage(y, x) = max(0, poissrnd(lambda));
            else
                noisyImage(y, x) = 0;
            end
        end
    end
end
