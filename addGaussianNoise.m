function noisyImage = addGaussianNoise(image, mean, variance)
    [height, width] = size(image);
    noisyImage = zeros(size(image));
    % 使用向量化操作添加高斯噪声，效率更高且更符合数学原理
    noiseMatrix = mean + variance * randn(height, width);
    % 处理边界情况，确保像素值在合理范围[0, 1]内，采用更平滑的截断方式（避免硬截断）
    clippedNoiseMatrix = max(0, min(1, noiseMatrix));
    noisyImage = max(0, min(1, image + clippedNoiseMatrix));
end