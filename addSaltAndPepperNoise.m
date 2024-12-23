function noisyImage = addSaltAndPepperNoise(image, density)
    [height, width] = size(image);
    numPixels = height * width;
    numNoisePixels = round(numPixels * density);
    noisyImage = image;
    % 生成随机索引，确保每个噪声像素点只被选择一次（更精确的方式）
    noisePixelIndices = randperm(numPixels, numNoisePixels);
    % 分别统计盐噪声和椒噪声的数量（这里简单按照等概率分配，可调整）
    numSaltPixels = floor(numNoisePixels / 2);
    numPepperPixels = numNoisePixels - numSaltPixels;
    % 生成盐噪声像素索引
    saltPixelIndices = noisePixelIndices(1:numSaltPixels);
    % 生成椒噪声像素索引
    pepperPixelIndices = noisePixelIndices(numSaltPixels + 1:end);
    % 将对应索引的像素设置为盐噪声（1）或椒噪声（0）
    [ySalt, xSalt] = ind2sub([height, width], saltPixelIndices);
    noisyImage(sub2ind(size(image), ySalt, xSalt)) = 1;
    [yPepper, xPepper] = ind2sub([height, width], pepperPixelIndices);
    noisyImage(sub2ind(size(image), yPepper, xPepper)) = 0;
end