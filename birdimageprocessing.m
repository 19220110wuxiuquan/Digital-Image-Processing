function varargout = birdimageprocessing(varargin)
% BIRDIMAGEPROCESSING MATLAB code for birdimageprocessing.fig
%      BIRDIMAGEPROCESSING, by itself, creates a new BIRDIMAGEPROCESSING or raises the existing
%      singleton*.
%
%      H = BIRDIMAGEPROCESSING returns the handle to a new BIRDIMAGEPROCESSING or the handle to
%      the existing singleton*.
%
%      BIRDIMAGEPROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIRDIMAGEPROCESSING.M with the given input arguments.
%
%      BIRDIMAGEPROCESSING('Property','Value',...) creates a new BIRDIMAGEPROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before birdimageprocessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to birdimageprocessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help birdimageprocessing

% Last Modified by GUIDE v2.5 20-Dec-2024 23:22:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @birdimageprocessing_OpeningFcn, ...
                   'gui_OutputFcn',  @birdimageprocessing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before birdimageprocessing is made visible.
function birdimageprocessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to birdimageprocessing (see VARARGIN)

% Choose default command line output for birdimageprocessing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes birdimageprocessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = birdimageprocessing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
% --- Executes on button press in pushbutton1.
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
    % 打开文件选择对话框让用户选择一个图像文件
    [filename, pathname] = uigetfile({'*.jpg; *.jpeg; *.png; *.bmp','Image Files (*.jpg, *.jpeg, *.png, *.bmp)'; ...
                                      '*.*', 'All Files (*.*)'}, 'Select an Image');
    
    if isequal(filename,0) || isequal(pathname,0)
        % 如果用户取消了文件选择，就退出函数
        return;
    end
    
    % 构建完整的文件路径
    fullpath = fullfile(pathname, filename);
    
    % 读取图像文件
    img = imread(fullpath);
    
    % 显示图像
    % 假设你有一个 axes 或 image 控件用于显示图像，其标签为 'axes1'
    axes(handles.axes1); % 设置当前坐标轴为要显示图像的坐标轴
    imshow(img);         % 在坐标轴上显示图像
    drawnow;             % 更新图形窗口

    % 更新编辑框以显示所选图像的文件名
    set(handles.edit1, 'String', filename);

    % 将图像数据存储在 handles 结构体中以便其他回调函数访问
    handles.imageData = img; % 添加这行来保存图像数据
    handles.imagePath = fullpath;
    guidata(hObject, handles); % 确保更新 handles 结构体



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonHistogram.
    function pushbuttonHistogram_Callback(hObject, eventdata, handles)
    % 确保有一个打开的图像
    if ~isfield(handles, 'imageData') || isempty(handles.imageData)
        warndlg('请先选择一张图像', '无图像');
        return;
    end
    
    % 获取图像数据
    img = handles.imageData;
    
    % 如果图像是彩色的，转换为灰度图像
    if size(img, 3) > 1
        img = rgb2gray(img);
    end
    
    % 在axes2上显示直方图
    axes(handles.axes2);
    imhist(img);
    title('灰度直方图');

% --- Executes on button press in pushbuttonEqualize.
function pushbuttonEqualize_Callback(hObject, eventdata, handles)
    % 确保有一个打开的图像
    if ~isfield(handles, 'imageData') || isempty(handles.imageData)
        warndlg('请先选择一张图像', '无图像');
        return;
    end
    
    % 获取原始图像数据
    original_img = handles.imageData;
    
    % 如果图像是彩色的，转换为灰度图像副本进行处理
    if size(original_img, 3) > 1
        gray_img = rgb2gray(original_img);
    else
        gray_img = original_img; % 如果已经是灰度图像，则直接使用
    end
    
    % 执行直方图均衡化
    eq_gray_img = histeq(gray_img);
    
    % 显示均衡化后的直方图在axes3中
    axes(handles.axes3);
    imhist(eq_gray_img);
    title('均衡化后的灰度直方图');
    
    % 更新handles结构体中的图像数据，以便后续操作使用
    handles.equalizedImageData = eq_gray_img;
    guidata(hObject, handles);

% --- Executes on button press in pushbuttonMatch.
function pushbuttonMatch_Callback(hObject, eventdata, handles)
    % 确保有一个均衡化后的图像
    if ~isfield(handles, 'equalizedImageData') || isempty(handles.equalizedImageData)
        warndlg('请先执行直方图均衡化', '无均衡化图像');
        return;
    end
    
    % 使用均衡化后的图像作为源图像
    src_img = handles.equalizedImageData;
    
    % 如果用户已经选择了参考图像，则直接使用它
    if isfield(handles, 'referenceImageData') && ~isempty(handles.referenceImageData)
        ref_img = handles.referenceImageData;
    else
        % 否则，打开参考图像
        [ref_filename, ref_pathname] = uigetfile({'*.jpg; *.jpeg; *.png; *.bmp','Image Files (*.jpg, *.jpeg, *.png, *.bmp)'; ...
                                                  '*.*', 'All Files (*.*)'}, 'Select Reference Image');
        if isequal(ref_filename,0) || isequal(ref_pathname,0)
            % 如果用户取消了文件选择，就退出函数
            return;
        end
        
        ref_fullpath = fullfile(ref_pathname, ref_filename);
        ref_img = imread(ref_fullpath);
        
        % 如果参考图像是彩色的，转换为灰度图像
        if size(ref_img, 3) > 1
            ref_img = rgb2gray(ref_img);
        end
        
        % 保存参考图像到handles结构中，以便之后可以直接使用
        handles.referenceImageData = ref_img;
        guidata(hObject, handles);
    end
    
    % 执行直方图匹配
    matched_img = imhistmatch(src_img, ref_img); % 使用MATLAB内置的imhistmatch函数
    
    % 显示匹配后的直方图在axes3中
    axes(handles.axes3);
    imhist(matched_img);
    title('匹配后的灰度直方图');
    
    % 更新handles结构体中的图像数据
    handles.matchedImageData = matched_img;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 确保有一个打开的图像
    if ~isfield(handles, 'imageData') || isempty(handles.imageData)
        warndlg('请先选择一张图像', '无图像');
        return;
    end
    
    % 获取原始图像数据
    img = handles.imageData;
    
    % 如果图像是彩色的，转换为灰度图像副本进行处理
    if size(img, 3) > 1
        gray_img = rgb2gray(img);
    else
        gray_img = img; % 如果已经是灰度图像，则直接使用
    end
    
    % 在axes4上显示灰度图像
    axes(handles.axes4);
    imshow(gray_img);
    title('灰度图像');
    
    % 更新handles结构体中的图像数据，以便后续操作使用
    handles.grayImageData = gray_img;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
    % 确保有一个灰度化的图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = double(handles.grayImageData); % 将图像转换为double类型以进行计算
    
    % 定义线性变换参数（这里假设简单增强对比度）
    alpha = 1.2; % 放大系数
    beta = -20;  % 偏移量
    
    % 应用线性变换
    linear_transformed_img = alpha * gray_img + beta;
    
    % 裁剪超出[0, 255]范围的值
    linear_transformed_img(linear_transformed_img < 0) = 0;
    linear_transformed_img(linear_transformed_img > 255) = 255;
    
    % 转换回uint8类型
    linear_transformed_img = uint8(linear_transformed_img);
    
    % 在axes5上显示线性变换后的图像
    axes(handles.axes5);
    imshow(linear_transformed_img);
    title('线性变换后的图像');
    
    % 更新handles结构体中的图像数据
    handles.linearTransformedImageData = linear_transformed_img;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
    % 确保有一个灰度化的图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = double(handles.grayImageData);
    
    % 应用对数变换
    c = 255 / log(1 + max(gray_img(:))); % 对数变换的常数c
    log_transformed_img = uint8(c * log(1 + gray_img));
    
    % 在axes5上显示对数变换后的图像
    axes(handles.axes5);
    imshow(log_transformed_img);
    title('对数变换后的图像');
    
    % 更新handles结构体中的图像数据
    handles.logTransformedImageData = log_transformed_img;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
    % 确保有一个灰度化的图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = double(handles.grayImageData);
    
    % 定义指数变换参数
    gamma = 0.4; % 指数变换的伽马值
    
    % 应用指数变换
    exponential_transformed_img = uint8(255 * ((gray_img / 255).^gamma));
    
    % 在axes5上显示指数变换后的图像
    axes(handles.axes5);
    imshow(exponential_transformed_img);
    title('指数变换后的图像');
    
    % 更新handles结构体中的图像数据
    handles.exponentialTransformedImageData = exponential_transformed_img;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    % 确保有一个灰度化的图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = double(handles.grayImageData); % 转换为double类型以便于计算
    
    % 提示用户输入缩放比例
    prompt = {'请输入宽度缩放因子:', '请输入高度缩放因子:'};
    dlg_title = '输入缩放参数';
    num_lines = 1;
    def_input = {'1.5', '1.5'};
    answer = inputdlg(prompt, dlg_title, num_lines, def_input);
    
    if isempty(answer) || any(cellfun(@isempty, answer))
        return; % 用户取消了对话框或未填写所有字段
    end
    
    scale_factor_x = str2double(answer{1});
    scale_factor_y = str2double(answer{2});
    
    % 输入验证
    if isnan(scale_factor_x) || isnan(scale_factor_y) || ...
       scale_factor_x <= 0 || scale_factor_y <= 0
        warndlg('请输入有效的正数作为缩放因子', '无效输入');
        return;
    end
    
    % 获取输入图像的尺寸
    [m, n] = size(gray_img);
    
    % 计算放大后的图像尺寸，采用四舍五入
    new_m = round(m * scale_factor_y);
    new_n = round(n * scale_factor_x);
    
    % 创建一个新的空白图像
    scaled_img = zeros(new_m, new_n);
    
    % 计算每个新像素的值（双线性插值）
    for i = 1:new_m
        for j = 1:new_n
            % 计算在原图像中的坐标
            x = (j - 0.5) / scale_factor_x - 0.5;
            y = (i - 0.5) / scale_factor_y - 0.5;
            
            % 向上取整和向下取整
            x1 = floor(x); % 向下
            x2 = ceil(x);  % 向上
            y1 = floor(y);
            y2 = ceil(y);
            
            % 确保不超出图像边界
            x1 = max(1, min(x1, n-1));
            x2 = max(1, min(x2, n-1));
            y1 = max(1, min(y1, m-1));
            y2 = max(1, min(y2, m-1));
            
            % 双线性插值计算
            if x2 == x1 && y2 == y1
                value = gray_img(y1+1, x1+1);
            else
                Q11 = gray_img(y1+1, x1+1);
                Q21 = gray_img(y2+1, x1+1);
                Q12 = gray_img(y1+1, x2+1);
                Q22 = gray_img(y2+1, x2+1);
                
                value = (Q11 * (x2-x) * (y2-y) + ...
                         Q21 * (x-x1) * (y2-y) + ...
                         Q12 * (x2-x) * (y-y1) + ...
                         Q22 * (x-x1) * (y-y1));
            end
            
            scaled_img(i, j) = value;
        end
    end
    
    % 将图像转换回uint8类型
    scaled_img = uint8(scaled_img);
    
    % 在axes5上显示缩放后的图像
    axes(handles.axes5);
    cla; % 清除坐标轴以确保新图像正确显示
    imshow(scaled_img);
    title(['缩放因子: ', num2str(scale_factor_x), 'x', num2str(scale_factor_y)]);
    
    % 更新handles结构体中的图像数据
    handles.scaledImageData = scaled_img;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
    % 确保有一个灰度化的图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = handles.grayImageData;
    
    % 提示用户输入旋转角度
    angle = inputdlg('请输入旋转角度（顺时针方向，单位：度）:', '输入旋转角度', 1, {'0'});
    
    if isempty(angle)
        return; % 用户取消了对话框
    end
    
    angle_degrees = str2double(angle{1});
    
    if isnan(angle_degrees)
        warndlg('请输入有效的数字作为旋转角度', '无效输入');
        return;
    end
    
    % 应用旋转变换
    rotated_img = imrotate(gray_img, -angle_degrees, 'bilinear', 'crop'); % 使用双线性插值并裁剪图像
    
    % 在axes5上显示旋转变换后的图像
    axes(handles.axes5);
    imshow(rotated_img);
    title(['旋转角度: ', num2str(angle_degrees), '度']);
    
    % 更新handles结构体中的图像数据
    handles.rotatedImageData = rotated_img;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
    % 确保有一个打开的灰度图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 使用列表对话框让用户选择噪声类型
    options = {'椒盐噪声', '高斯噪声', '泊松噪声'};
    noiseType = listdlg('PromptString', '请选择噪声类型：', ...
                        'ListString', options, ...
                        'Name', '噪声类型选择');
    
    if isempty(noiseType)
        return; % 用户取消了对话框
    end
    
    % 根据用户选择添加相应的噪声
    switch options{noiseType}
        case '椒盐噪声'
            noisy_img = imnoise(gray_img, 'salt & pepper', 0.05);
        case '高斯噪声'
            noisy_img = imnoise(gray_img, 'gaussian', 0, 0.01);
        case '泊松噪声'
            noisy_img = imnoise(gray_img, 'poisson');
        otherwise
            error('未知的噪声类型');
    end
    
    % 显示加噪后的图像
    axes(handles.axes5);
    imshow(noisy_img);
    title('加噪后的图像');
    
    % 更新handles结构体中的图像数据
    handles.noisyImageData = noisy_img;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
    % 确保有一个加噪后的图像
    if ~isfield(handles, 'noisyImageData') || isempty(handles.noisyImageData)
        warndlg('请先添加噪声', '无噪声图像');
        return;
    end
    
    % 获取加噪后的图像数据
    noisy_img = handles.noisyImageData;
    
    % 使用列表对话框让用户选择滤波器类型
    options = {'均值滤波', '高斯滤波', '中值滤波', '双边滤波', '自定义滤波'};
    filterType = listdlg('PromptString', '请选择空域滤波器类型：', ...
                         'ListString', options, ...
                         'Name', '空域滤波器类型选择');
    
    if isempty(filterType)
        return; % 用户取消了对话框
    end
    
    filtered_img = [];
    
    % 应用所选的空域滤波器
    switch options{filterType}
        case '均值滤波'
            h = fspecial('average', [3 3]);
            filtered_img = imfilter(noisy_img, h);
        case '高斯滤波'
            h = fspecial('gaussian', [3 3], 0.5);
            filtered_img = imfilter(noisy_img, h);
        case '中值滤波'
            filtered_img = medfilt2(noisy_img);
        case '双边滤波'
            filtered_img = imgaussfilt(noisy_img, 2); % 双边滤波器的一个近似
        case '自定义滤波'
            prompt = {'请输入滤波器尺寸:', '请输入标准差:'};
            dlg_title = '自定义高斯滤波器参数';
            num_lines = 1;
            def_input = {'5', '1'};
            answer = inputdlg(prompt, dlg_title, num_lines, def_input);
            
            if isempty(answer) || any(cellfun(@isempty, answer))
                return; % 用户取消了对话框或未填写所有字段
            end
            
            size_val = str2double(answer{1});
            sigma_val = str2double(answer{2});
            
            if isnan(size_val) || isnan(sigma_val) || size_val <= 0 || sigma_val <= 0
                warndlg('请输入有效的正数作为滤波器尺寸和标准差', '无效输入');
                return;
            end
            
            h = fspecial('gaussian', [size_val size_val], sigma_val);
            filtered_img = imfilter(noisy_img, h);
        otherwise
            error('未知的滤波器类型');
    end
    
    % 显示滤波后的图像
    axes(handles.axes6);
    imshow(filtered_img);
    title('空域滤波后的图像');
    
    % 更新handles结构体中的图像数据
    handles.filteredSpatialData = filtered_img;
    guidata(hObject, handles);
    
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
    % 确保有一个加噪后的图像
    if ~isfield(handles, 'noisyImageData') || isempty(handles.noisyImageData)
        warndlg('请先添加噪声', '无噪声图像');
        return;
    end
    
    % 获取加噪后的图像数据
    noisy_img = im2double(handles.noisyImageData);
    
    % 计算图像的二维快速傅里叶变换
    F = fftshift(fft2(noisy_img));
    
    % 使用列表对话框让用户选择频域滤波器类型
    options = {'理想低通滤波', '巴特沃斯低通滤波', '高斯低通滤波'};
    filterType = listdlg('PromptString', '请选择频域滤波器类型：', ...
                         'ListString', options, ...
                         'Name', '频域滤波器类型选择');
    
    if isempty(filterType)
        return; % 用户取消了对话框
    end
    
    % 创建并应用所选的频域滤波器
    [M, N] = size(F);
    [U, V] = meshgrid(-fix(N/2):ceil(N/2)-1, -fix(M/2):ceil(M/2)-1);
    D = sqrt(U.^2 + V.^2);
    cutoffFreq = 30; % 截止频率
    
    switch options{filterType}
        case '理想低通滤波'
            H = double(D <= cutoffFreq);
        case '巴特沃斯低通滤波'
            n = 2; % 滤波器阶数
            H = 1 ./ (1 + (D / cutoffFreq).^(2*n));
        case '高斯低通滤波'
            H = exp(-(D.^2) / (2 * cutoffFreq^2));
        otherwise
            error('未知的频域滤波器类型');
    end
    
    % 应用滤波器
    G = F .* H;
    
    % 逆傅里叶变换回到空间域
    filtered_img = real(ifft2(ifftshift(G)));
    
    % 显示滤波后的图像
    axes(handles.axes6);
    imshow(filtered_img, []);
    title('频域滤波后的图像');
    
    % 更新handles结构体中的图像数据
    handles.filteredFrequencyData = filtered_img;
    guidata(hObject, handles);
    


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 定义Roberts算子卷积核
    robertsKernelX = [-1 0; 0 1];
    robertsKernelY = [0 -1; 1 0];
    
    % 应用Roberts算子
    g1 = imfilter(gray_img, robertsKernelX, 'replicate');
    g2 = imfilter(gray_img, robertsKernelY, 'replicate');
    edge_img = sqrt(g1.^2 + g2.^2);
    
    % 显示边缘检测后的图像
    axes(handles.axes6);
    imshow(edge_img, []);
    title('Roberts算子边缘检测后的图像');
    
    % 更新handles结构体中的图像数据
    handles.edgeDetectedImageData = edge_img;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 确保有一个打开的灰度图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 使用MATLAB内置函数进行Prewitt边缘检测
    edge_img = edge(gray_img, 'prewitt');
    
    % 显示边缘检测后的图像
    axes(handles.axes6);
    imshow(edge_img);
    title('Prewitt算子边缘检测后的图像');
    
    % 更新handles结构体中的图像数据
    handles.edgeDetectedImageData = edge_img;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 确保有一个打开的灰度图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 使用MATLAB内置函数进行Sobel边缘检测
    edge_img = edge(gray_img, 'sobel');
    
    % 显示边缘检测后的图像
    axes(handles.axes6);
    imshow(edge_img);
    title('Sobel算子边缘检测后的图像');
    
    % 更新handles结构体中的图像数据
    handles.edgeDetectedImageData = edge_img;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % 确保有一个打开的灰度图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 使用MATLAB内置函数进行拉普拉斯边缘检测
    laplacianKernel = fspecial('laplacian', 0); % 创建拉普拉斯算子内核
    edge_img = imfilter(gray_img, laplacianKernel); % 应用拉普拉斯算子
    edge_img = edge_img > mean(edge_img(:)); % 二值化
    
    % 显示边缘检测后的图像
    axes(handles.axes6);
    imshow(edge_img);
    title('拉普拉斯算子边缘检测后的图像');
    
    % 更新handles结构体中的图像数据
    handles.edgeDetectedImageData = edge_img;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% 确保有一个打开的灰度图像和原始彩色图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData) || ...
       ~isfield(handles, 'imageData') || isempty(handles.imageData)
        warndlg('请先选择一张图像并将其灰度化', '无图像');
        return;
    end
    
    % 获取灰度图像数据和原始彩色图像数据
    gray_img = handles.grayImageData;
    original_img = handles.imageData;
    
    % 图像预处理：去噪
    smoothed_img = imgaussfilt(gray_img, 2); % 高斯滤波去噪
    
    % 使用Otsu法计算最优阈值并二值化图像
    level = graythresh(smoothed_img);
    binary_img = imbinarize(smoothed_img, level);
    
    % 应用形态学操作：闭运算以填充孔洞并连接断开的目标部分
    se = strel('disk', 5); % 定义结构元素
    closed_img = imclose(binary_img, se); % 闭运算
    
    % 查找连通区域并标记
    labeled_img = bwlabel(closed_img);
    stats = regionprops(labeled_img, 'Area', 'BoundingBox', 'Centroid');
    
    % 过滤掉小面积的对象（假设目标是较大的对象）
    min_object_area = 500; % 根据实际情况调整最小面积阈值
    large_objects = [];
    for i = 1:length(stats)
        if stats(i).Area > min_object_area
            bbox = stats(i).BoundingBox;
            large_objects = [large_objects; bbox];
        end
    end
    
    % 显示提取的目标在原始彩色图像上
    axes(handles.axes7); % 假设axes7用于显示提取的目标
    imshow(original_img); % 显示原始彩色图像作为背景
    hold on;
    for i = 1:size(large_objects, 1)
        rectangle('Position', large_objects(i,:), 'EdgeColor', 'r', 'LineWidth', 2);
    end
    title('Otsu法提取的目标');
    hold off;
    
    % 更新handles结构体中的提取目标数据
    handles.extractedObjects = large_objects;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 提取LBP特征
    lbp_features = extractLBPFeatures(gray_img);
    
    % 显示原始图像
    axes(handles.axes8); % 使用指定的显示组件
    imshow(gray_img);
    title('LBP特征 (原始图像)');
    
    % 打印LBP特征信息
    disp('原始图像的LBP特征:');
    disp(lbp_features);
    
    % 更新handles结构体中的特征数据
    handles.lbpFeaturesOriginal = lbp_features;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
    if ~isfield(handles, 'extractedObjects') || isempty(handles.extractedObjects) || ...
       ~isfield(handles, 'imageData') || isempty(handles.imageData)
        warndlg('请先提取目标区域', '无目标区域');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 提取目标区域
    target_mask = false(size(gray_img));
    for i = 1:size(handles.extractedObjects, 1)
        bbox = round(handles.extractedObjects(i,:));
        target_mask(bbox(2):bbox(2)+bbox(4)-1, bbox(1):bbox(1)+bbox(3)-1) = true;
    end
    
    % 应用掩码获取目标区域的灰度图像
    target_gray_img = gray_img .* double(target_mask);
    
    % 提取LBP特征
    lbp_features = extractLBPFeatures(target_gray_img);
    
    % 显示目标区域的LBP特征
    axes(handles.axes8); % 使用指定的显示组件
    imshow(target_gray_img);
    title('目标区域 (LBP特征)');
    
    % 打印LBP特征信息
    disp('目标区域的LBP特征:');
    disp(lbp_features);
    
    % 更新handles结构体中的特征数据
    handles.lbpFeaturesTarget = lbp_features;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
     if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 直接在这里实现HOG特征提取逻辑
    img = double(gray_img);
    [h, w] = size(img);
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
    
    % 显示原始图像
    axes(handles.axes8); % 使用指定的显示组件
    imshow(gray_img);
    title('原始图像');
    
    % 创建一个新的figure窗口来展示HOG特征的mesh图
    figure;
    mesh(hog_features);
    title('HOG特征 (mesh)');
    xlabel('Block Index');
    ylabel('Feature Vector Elements');
    zlabel('Magnitude');
    
    % 打印HOG特征信息
    disp('原始图像的HOG特征:');
    disp(hog_features);
    
    % 更新handles结构体中的特征数据
    handles.hogFeaturesOriginal = hog_features;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
  if ~isfield(handles, 'extractedObjects') || isempty(handles.extractedObjects) || ...
       ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先提取目标区域', '无目标区域');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 提取目标区域
    target_mask = false(size(gray_img));
    for i = 1:size(handles.extractedObjects, 1)
        bbox = round(handles.extractedObjects(i, :));
        target_mask(bbox(2):bbox(2)+bbox(4)-1, bbox(1):bbox(1)+bbox(3)-1) = true;
    end
    
    % 应用掩码获取目标区域的灰度图像
    target_gray_img = gray_img .* double(target_mask);
    
    % 直接在这里实现HOG特征提取逻辑
    img = double(target_gray_img);
    [h, w] = size(img);
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
    
    % 显示目标区域的灰度图像
    axes(handles.axes8); % 使用指定的显示组件
    imshow(target_gray_img);
    title('目标区域 (灰度图像)');
    
    % 创建一个新的figure窗口来展示HOG特征的mesh图
    figure;
    mesh(hog_features);
    title('目标区域 (HOG特征)');
    xlabel('Block Index');
    ylabel('Feature Vector Elements');
    zlabel('Magnitude');
    
    % 打印HOG特征信息
    disp('目标区域的HOG特征:');
    disp(hog_features);
    
    % 更新handles结构体中的特征数据
    handles.hogFeaturesTarget = hog_features;
    guidata(hObject, handles);