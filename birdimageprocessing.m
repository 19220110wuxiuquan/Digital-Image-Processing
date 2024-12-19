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

% Last Modified by GUIDE v2.5 19-Dec-2024 15:50:53

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
