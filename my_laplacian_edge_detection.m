function edge_img = my_laplacian_edge_detection(gray_img)
    % MY_LAPLACIAN_EDGE_DETECTION 使用拉普拉斯算子进行边缘检测。
    %
    % 输入:
    %   gray_img - 灰度输入图像。
    %
    % 输出:
    %   edge_img - 边缘检测后的二值图像。

    % 将图像转换为 double 类型以确保精度，并归一化到 [0, 1] 范围
    gray_img = im2double(gray_img);

    % 定义拉普拉斯算子卷积核（常用形式）
    laplacianKernel = [0 -1 0; -1 4 -1; 0 -1 0];

    % 对图像进行边界扩充，以便处理边缘像素（采用复制边界的方式扩充）
    padded_gray_img = padarray(gray_img, [1, 1], 'replicate');

    % 使用 conv2 函数进行卷积操作，提高效率
    conv_result = conv2(padded_gray_img, laplacianKernel, 'valid');

    % 进行二值化处理，这里使用 Otsu 方法自动选择阈值
    level = graythresh(conv_result);
    edge_img = imbinarize(conv_result, level);

    % 可选步骤：应用形态学操作去除小对象或填补空洞
    % edge_img = bwareaopen(edge_img, 50); % 移除面积小于50个像素的对象
    % edge_img = imfill(edge_img, 'holes'); % 填补封闭区域内的孔洞

    % 确保输出图像的数据类型与输入一致
    edge_img = cast(edge_img, class(gray_img));