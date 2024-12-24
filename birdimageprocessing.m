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

% Last Modified by GUIDE v2.5 24-Dec-2024 15:20:02

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
        img = my_rgb2gray(img);
    end
    
    % 在axes2上显示直方图
    axes(handles.axes2);
    my_imhist(img);
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
        gray_img = my_rgb2gray(original_img);
    else
        gray_img = original_img; % 如果已经是灰度图像，则直接使用
    end
    
    % 执行直方图均衡化
    eq_gray_img = histeq(gray_img);
    
    % 显示均衡化后的直方图在axes3中
    axes(handles.axes3);
    my_imhist(eq_gray_img);
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
            ref_img = my_rgb2gray(ref_img);
        end
        
        % 保存参考图像到handles结构中，以便之后可以直接使用
        handles.referenceImageData = ref_img;
        guidata(hObject, handles);
    end
    
    % 执行直方图匹配
    matched_img = my_histmatch(src_img, ref_img); 
    
    % 显示匹配后的直方图在axes3中
    axes(handles.axes3);
    my_imhist(matched_img);
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
        gray_img = my_rgb2gray(img);
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
    gray_img = handles.grayImageData; % 不需要显式转换为double类型，由my_linear_transform处理
    
    % 定义线性变换参数（这里假设简单增强对比度）
    alpha = 1.2; % 放大系数
    beta = -20;  % 偏移量
    
    % 应用线性变换
    linear_transformed_img = my_linear_transform(gray_img, alpha, beta);
    
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
    gray_img = handles.grayImageData;
    
    % 应用对数变换
    log_transformed_img = my_log_transform(gray_img);
    
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
    gray_img = handles.grayImageData;
    
    % 定义指数变换参数
    gamma = 0.4; % 指数变换的伽马值
    
    % 应用指数变换
    exponential_transformed_img = my_exponential_transform(gray_img, gamma);
    
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
    def_input = {'2', '1.5'};
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
   rotated_img = my_imrotate(gray_img, -angle_degrees, 'method', 'bilinear', 'crop', true);
    
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
    
    % 定义每个噪声类型的参数和默认值
    switch options{noiseType}
        case '椒盐噪声'
            prompt = {'请输入密度 (0-1)：'};
            dlgtitle = '椒盐噪声参数';
            definput = {'0.05'};
            rangeHint = '密度范围为0到1之间';
            
        case '高斯噪声'
            prompt = {'请输入均值：', '请输入方差 (0-1)：'};
            dlgtitle = '高斯噪声参数';
            definput = {'0', '0.01'};
            rangeHint = '均值可以是任意实数，方差范围为0到1之间';
            
        case '泊松噪声'
            % 泊松噪声没有额外参数
            noisy_img = imnoise(gray_img, 'poisson');
            
        otherwise
            error('未知的噪声类型');
    end

    % 如果不是泊松噪声，则获取用户输入的参数
    if ~strcmp(options{noiseType}, '泊松噪声')
        userInputs = inputdlg(prompt, dlgtitle, 1, definput);
        if isempty(userInputs)
            return; % 用户取消了对话框
        end
        
        % 将输入转换为数值并应用噪声
        params = cellfun(@str2double, userInputs, 'UniformOutput', false);
        if any(cellfun(@isnan, params))
            warndlg('请输入有效的数字参数', '无效输入');
            return;
        end
        
        try
            switch options{noiseType}
                case '椒盐噪声'
                    density = params{1};
                    if density < 0 || density > 1
                        warndlg('密度应在0到1之间', '参数超出范围');
                        return;
                    end
                    noisy_img = imnoise(gray_img, 'salt & pepper', density);
                    
                case '高斯噪声'
                    mean_val = params{1};
                    variance = params{2};
                    if variance < 0 || variance > 1
                        warndlg('方差应在0到1之间', '参数超出范围');
                        return;
                    end
                    noisy_img = imnoise(gray_img, 'gaussian', mean_val, variance);
            end
        catch ME
            warndlg(['发生错误: ' ME.message], '添加噪声失败');
            return;
        end
    end
    
    % 显示加噪后的图像
    axes(handles.axes5);
    imshow(noisy_img);
    title(['加噪后的图像 (' options{noiseType} ')']);
    
    % 更新handles结构体中的图像数据
    handles.noisyImageData = noisy_img;
    guidata(hObject, handles);

    % 提示参数范围
    msgbox(rangeHint, '参数范围提示');

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
    filterType = listdlg('PromptString', '请选择空域滤波器类型：',...
                         'ListString', options,...
                         'Name', '空域滤波器类型选择');
    
    if isempty(filterType)
        return; % 用户取消了对话框
    end
    
    filtered_img = [];
    
    % 应用所选的空域滤波器
    switch options{filterType}
        case '均值滤波'
            filtered_img = my_mean_filter(noisy_img, [3 3]);
        case '高斯滤波'
            filtered_img = my_gaussian_filter(noisy_img, [3 3], 0.5);
        case '中值滤波'
            filtered_img = my_median_filter(noisy_img);
        case '双边滤波'
            filtered_img = my_bilateral_filter(noisy_img, 1, 0.1); % 示例参数，可调整
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
            
            filtered_img = my_gaussian_filter(noisy_img, [size_val size_val], sigma_val);
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
    
    % 获取频谱尺寸
    [M, N] = size(F);
    
    % 使用列表对话框让用户选择频域滤波器类型
    options = {'理想低通滤波', '巴特沃斯低通滤波', '高斯低通滤波'};
    filterType = listdlg('PromptString', '请选择频域滤波器类型：',...
                         'ListString', options,...
                         'Name', '频域滤波器类型选择');
    
    if isempty(filterType)
        return; % 用户取消了对话框
    end
    
    % 设置截止频率（这里可以考虑后续做成可输入的形式来提高灵活性）
    cutoffFreq = 30; 
    % 滤波器阶数（针对巴特沃斯低通滤波，同样可考虑做成可调整形式）
    n = 2; 
    
    % 根据用户选择调用相应的滤波函数创建滤波器传递函数H
    switch options{filterType}
        case '理想低通滤波'
            H = idealLowpassFilter(M, N, cutoffFreq);
        case '巴特沃斯低通滤波'
            H = butterworthLowpassFilter(M, N, cutoffFreq, n);
        case '高斯低通滤波'
            H = gaussianLowpassFilter(M, N, cutoffFreq);
        otherwise
            error('未知的频域滤波器类型');
    end
    
    % 应用滤波器
    G = F.* H;
    
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

% 检查是否存在灰度图像数据，若不存在则弹出提示并返回
if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    % 获取灰度图像数据
    gray_img = im2double(handles.grayImageData);
    
    % 调用自定义的Roberts算子边缘检测函数进行边缘检测
    edge_img = my_roberts_edge_detection(gray_img);
    
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
    
    % 调用自定义的Prewitt算子边缘检测函数进行边缘检测
    edge_img = my_prewitt_edge_detection(gray_img);
    
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
    
    % 调用自定义的Sobel算子边缘检测函数进行边缘检测
    edge_img = my_sobel_edge_detection(gray_img);
    
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
    
    % 调用自定义的拉普拉斯算子边缘检测函数进行边缘检测
    edge_img = my_laplacian_edge_detection(gray_img);
    
    % 显示边缘检测后的图像
    axes(handles.axes6);
    imshow(edge_img);
    title('拉普拉斯算子边缘检测后的图像');
    
    % 更新handles结构体中的图像数据
    handles.edgeDetectedImageData = edge_img;
    guidata(hObject, handles);

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 [filename, pathname] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp','All Image Files'; ...
                                      '*.*','All Files'}, 'Select a Background Image');
    
    if isequal(filename, 0) || isequal(pathname, 0)
        % 用户取消了文件选择
        return;
    end
    
    % 构建完整的文件路径
    fullpath = fullfile(pathname, filename);
    
    % 读取背景图像
    background_img = imread(fullpath);
    
    % 将背景图像存储到handles结构体中
    handles.backgroundImage = background_img;
    guidata(hObject, handles); % 更新handles结构体
    
    % 显示背景图像名
    set(handles.edit2, 'String', filename);
    
    % 在axes3中显示背景图像
    axes(handles.axes3);
    imshow(background_img);
    title('背景图像');

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton19.
    function pushbutton19_Callback(hObject, eventdata, handles)
     % 检查是否已经加载了原图和背景图
    if ~isfield(handles, 'imageData') || isempty(handles.imageData) || ...
       ~isfield(handles, 'backgroundImage') || isempty(handles.backgroundImage)
        warndlg('请先加载原图和背景图', '缺少图像');
        return;
    end

    % 将图像转换为double类型
    original_img = im2double(handles.imageData);
    background_img = im2double(handles.backgroundImage);

    % 确保背景图像是灰度图像
    if size(background_img, 3) == 3
        backgroundGray = my_rgb2gray(background_img); % 转换为灰度图像
    else
        backgroundGray = background_img; % 如果已经是灰度图像，则直接使用
    end

    % 将背景图像调整到与原图相同的大小
    if ~isequal(size(original_img(:,:,1)), size(backgroundGray))
        backgroundGray = imresize(backgroundGray, size(original_img(:,:,1)));
    end

    % 将背景灰度图像归一化到[0, 1]范围，以便作为掩码使用
    backgroundMask = mat2gray(backgroundGray);

    % 使用掩码从原图中提取目标区域（图像乘法）
    if size(original_img, 3) == 3 % 如果是RGB图像
        targetImage = bsxfun(@times, original_img, cast(backgroundMask, class(original_img))); % 应用掩码到每个颜色通道并保持原始图像的数据类型
    else % 如果是灰度图像
        targetImage = bsxfun(@times, original_img, cast(backgroundMask, class(original_img))); % 应用掩码到灰度图像并保持原始图像的数据类型
    end

    % 显示结果
    axes(handles.axes7);
    imshow(targetImage);
    title('提取的目标区域');

    % 更新handles结构体中的目标数据
    handles.targetImage = targetImage;
    guidata(hObject, handles);


function pushbutton20_Callback(hObject, eventdata, handles)
    % 检查是否有灰度图像
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    gray_img = im2double(handles.grayImageData);
    
    % 提取并显示LBP特征图像
    lbp_img = computeLBPImage(gray_img); % 假设有一个computeLBPImage函数来生成LBP图像
    
    axes(handles.axes8); 
    imshow(lbp_img, []);
    title('原始图像的LBP特征');
    
    % 打印LBP特征信息
    disp('原始图像的LBP特征:');
    disp(computeLBPHistogram(lbp_img)); % 假设有一个函数来计算LBP直方图作为特征
    
    % 更新handles结构体中的特征数据
    handles.lbpFeaturesOriginal = computeLBPHistogram(lbp_img);
    guidata(hObject, handles);

function pushbutton21_Callback(hObject, eventdata, handles)
    % 检查是否有目标区域图像
    if ~isfield(handles, 'targetImage') || isempty(handles.targetImage)
        warndlg('请先提取目标区域', '无目标区域');
        return;
    end
    
    target_gray_img = my_rgb2gray(im2double(handles.targetImage));
    
    % 提取并显示目标区域的LBP特征图像
    lbp_img_target = computeLBPImage(target_gray_img);
    
    axes(handles.axes8); 
    imshow(lbp_img_target, []);
    title('目标区域的LBP特征');
    
    % 打印LBP特征信息
    disp('目标区域的LBP特征:');
    disp(computeLBPHistogram(lbp_img_target));
    
    % 更新handles结构体中的特征数据
    handles.lbpFeaturesTarget = computeLBPHistogram(lbp_img_target);
    guidata(hObject, handles);
    
% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
    if ~isfield(handles, 'grayImageData') || isempty(handles.grayImageData)
        warndlg('请先将图像灰度化', '无灰度图像');
        return;
    end
    
    gray_img = im2double(handles.grayImageData);
    
    % 使用原始的HOG特征提取逻辑
    hog_features = extractHOGFeaturesManual(gray_img);
    
    % 显示原始图像
    axes(handles.axes8); 
    imshow(gray_img);
    title('原始图像');
    
    % 创建一个新的figure窗口来展示HOG特征的mesh图
    figure;
    mesh(hog_features);
    title('原始图像的HOG特征');
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
    if ~isfield(handles, 'targetImage') || isempty(handles.targetImage)
        warndlg('请先提取目标区域', '无目标区域');
        return;
    end
    
    target_gray_img = rgb2gray(im2double(handles.targetImage)); % 假设targetImage可能是RGB
    
    % 使用原始的HOG特征提取逻辑
    hog_features = extractHOGFeaturesManual(target_gray_img);
    
    % 显示目标区域的灰度图像
    axes(handles.axes8); 
    imshow(target_gray_img);
    title('目标区域 (灰度图像)');
    
    % 创建一个新的figure窗口来展示HOG特征的mesh图
    figure;
    mesh(hog_features);
    title('目标区域的HOG特征');
    xlabel('Block Index');
    ylabel('Feature Vector Elements');
    zlabel('Magnitude');
    
    % 打印HOG特征信息
    disp('目标区域的HOG特征:');
    disp(hog_features);
    
    % 更新handles结构体中的特征数据
    handles.hogFeaturesTarget = hog_features;
    guidata(hObject, handles);


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % 获取之前存储的图像数据
    img = handles.imageData;

    % 初始化 BirdClassifier 类的对象
    birdClassifier = BirdClassifier();

    % 使用 BirdClassifier 对象进行预测
    predictionResult = birdClassifier.predictBirdType(img);

    % 将预测结果显示在 edit4 编辑框中
    set(handles.edit4, 'String', predictionResult);

    % 更新图形界面以反映更改
    guidata(hObject, handles);

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
