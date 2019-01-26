function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 18-Jan-2019 13:01:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;
global dt;
% Load model
dt = loadCompactModel('model_decision_tree.mat');

% Load logo 1
axes(handles.logo2_fig);
logo2 = imread('logo2.jpg');
image(logo2);
axis off;
axis image;

% Load logo telkom
axes(handles.telkom_logo);
logo = imread('logo_telkom.png');
image(logo);
axis off;
axis image;

% Load pas foto
axes(handles.foto_fig);
pas_foto = imread('football.jpg');
image(pas_foto);
axis off;
axis image;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ekstraksi_btn.
function ekstraksi_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ekstraksi_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global audio_mfcc;
global data_audio;
global audio_mono;
global ciri;

fs = 16000;
nfft = 2^12;
K = nfft/2+1;
M = 13;
hz2mel = @(hz)(1127*log(1+hz/700));
mel2hz = @(mel)(700*exp(mel/1127)-700);
[H, freq] = trifbank(M, K, [0 7000], fs, hz2mel, mel2hz);
audio_mono = stereo_to_mono(data_audio);
[ciri, audio_mfcc] = ekstraksi_ciri(audio_mono);
axes(handles.ekstraksi_fig);
plot(freq,H);
set(gca, 'box', 'off');

% --- Executes on button press in hasil_btn.
function hasil_btn_Callback(hObject, eventdata, handles)
% hObject    handle to hasil_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dt;
global ciri;
global prediction;
prediction = dt.predict(ciri);
set(handles.hasil_txt, 'string', prediction);
view(dt, 'Mode', 'Graph');


function hasil_txt_Callback(hObject, eventdata, handles)
% hObject    handle to hasil_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hasil_txt as text
%        str2double(get(hObject,'String')) returns contents of hasil_txt as a double


% --- Executes during object creation, after setting all properties.
function hasil_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hasil_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset_btn.
function reset_btn_Callback(hObject, eventdata, handles)
% hObject    handle to reset_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.filename_txt,'String','');
cla(handles.file_fig);
cla(handles.spectrogram1_fig);
cla(handles.spectrogram2_fig);

function filename_txt_Callback(hObject, eventdata, handles)
% hObject    handle to filename_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename_txt as text
%        str2double(get(hObject,'String')) returns contents of filename_txt as a double

% --- Executes during object creation, after setting all properties.
function filename_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_btn.
function browse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to browse_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_audio;
global filename_audio pathname_audio;
[filename_audio, pathname_audio] = uigetfile({'*.wav'}, 'File Selector');
handles.my_audio = strcat(pathname_audio, filename_audio);
set(handles.filename_txt, 'string', filename_audio);

data_audio = audioread(handles.my_audio);
axes(handles.file_fig);
plot(data_audio);
axes(handles.spectrogram1_fig);
spectrogram(data_audio(:,1), 'yaxis');

% --- Executes on button press in play_btn.
function play_btn_Callback(hObject, eventdata, handles)
% hObject    handle to play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data_audio;
sound(data_audio, 44100, 16);
