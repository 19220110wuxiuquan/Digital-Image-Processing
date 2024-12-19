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

% Last Modified by GUIDE v2.5 19-Dec-2024 21:25:21

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


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
    

% --- Executes on button press in pushbutton13.
    function pushbutton13_Callback(hObject, eventdata, handles)
    