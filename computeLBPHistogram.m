function hist = computeLBPHistogram(lbp_img)
    % 将LBP图像转换为线性索引并计算直方图
    bins = 2^8; % 假设我们有8个邻居，所以有256个可能的LBP值
    hist = histcounts(double(lbp_img(:)), 0:bins);

    % 归一化直方图
    hist = hist / sum(hist);