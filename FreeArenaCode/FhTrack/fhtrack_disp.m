function varargout = fhtrack_disp(varargin)
% FHTRACK_DISP MATLAB code for fhtrack_disp.fig
%      FHTRACK_DISP, by itself, creates a new FHTRACK_DISP or raises the existing
%      singleton*.
%
%      H = FHTRACK_DISP returns the handle to a new FHTRACK_DISP or the handle to
%      the existing singleton*.
%
%      FHTRACK_DISP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FHTRACK_DISP.M with the given input arguments.
%
%      FHTRACK_DISP('Property','Value',...) creates a new FHTRACK_DISP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fhtrack_disp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fhtrack_disp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fhtrack_disp

% Last Modified by GUIDE v2.5 10-Jun-2018 12:13:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fhtrack_disp_OpeningFcn, ...
                   'gui_OutputFcn',  @fhtrack_disp_OutputFcn, ...
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


% --- Executes just before fhtrack_disp is made visible.
function fhtrack_disp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fhtrack_disp (see VARARGIN)

% Choose default command line output for fhtrack_disp
handles.output = hObject;
fhtrack_addhandles('disp',hObject);
set(hObject,'toolbar','figure');
fhtrack_initialization('disp');

addlistener(handles.SliderMain,'ContinuousValueChange',@(src,event) fhtrack_dispslidermainfunc(hObject,handles));
addlistener(handles.SliderCMin,'ContinuousValueChange',@(src,event) fhtrack_dispslidermainfunc(hObject,handles));
addlistener(handles.SliderCMax,'ContinuousValueChange',@(src,event) fhtrack_dispslidermainfunc(hObject,handles));
addlistener(handles.SliderGamma,'ContinuousValueChange',@(src,event) fhtrack_dispslidermainfunc(hObject,handles));

% for manual correction of tracking
fhtrack_manualtrack;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fhtrack_disp wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function fhtrack_dispslidermainfunc(hObject,handles)
global gh
gh.data.cFrame=round(get(gh.disp.SliderMain,'Value')*(gh.data.sze(3)-1)+1);
gh.data.cMax=get(gh.disp.SliderCMax,'Value');
gh.data.cMin=get(gh.disp.SliderCMin,'Value');
gh.data.Gamma=get(gh.disp.SliderGamma,'Value');
set(gh.disp.TextCFrame,'String',num2str(gh.data.cFrame));
fhtrack_dispdrawfunc;
guidata(hObject,handles);


% --- Outputs from this function are returned to the command line.
function varargout = fhtrack_disp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ChckbxColorCode.
function ChckbxColorCode_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxColorCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_dispdrawfunc;
% Hint: get(hObject,'Value') returns toggle state of ChckbxColorCode


% --- Executes on button press in ChckbxDispSF.
function ChckbxDispSF_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxDispSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_dispdrawfunc;
% Hint: get(hObject,'Value') returns toggle state of ChckbxDispSF


% --- Executes on slider movement.
function SliderMain_Callback(hObject, eventdata, handles)
% hObject    handle to SliderMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderMain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderMain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ChckbxAddMask.
function ChckbxAddMask_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxAddMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_chckbxfunc('disp',hObject);
% Hint: get(hObject,'Value') returns toggle state of ChckbxAddMask


% --- Executes on button press in ChckbxRemoveMask.
function ChckbxRemoveMask_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxRemoveMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_chckbxfunc('disp',hObject);
% Hint: get(hObject,'Value') returns toggle state of ChckbxRemoveMask


% --- Executes on slider movement.
function SliderGamma_Callback(hObject, eventdata, handles)
% hObject    handle to SliderGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderGamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function SliderCMin_Callback(hObject, eventdata, handles)
% hObject    handle to SliderCMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderCMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderCMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function SliderCMax_Callback(hObject, eventdata, handles)
% hObject    handle to SliderCMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function SliderCMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderCMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function TextCFrame_Callback(hObject, eventdata, handles)
% hObject    handle to TextCFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_editframenumfunc;
% Hints: get(hObject,'String') returns contents of TextCFrame as text
%        str2double(get(hObject,'String')) returns contents of TextCFrame as a double


% --- Executes on button press in bttnFindTanslation.
function bttnFindTanslation_Callback(hObject, eventdata, handles)
% hObject    handle to bttnFindTanslation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;fhtrack_imregv3_first(1);toc


% --- Executes on button press in ChckbxAddRefObj.
function ChckbxAddRefObj_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxAddRefObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_chckbxfunc('disp',hObject);
% Hint: get(hObject,'Value') returns toggle state of ChckbxAddRefObj

% --- Executes on button press in ChckbxAddRefObj.
function ChckbxDispMaskNum_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxAddRefObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_dispdrawfunc;
% Hint: get(hObject,'Value') returns toggle state of ChckbxAddRefObj


% --- Executes on button press in bttnTrackFish.
function bttnTrackFish_Callback(hObject, eventdata, handles)
% hObject    handle to bttnTrackFish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_bttntrackallfunc;


% --- Executes on button press in bttn_trackvidfunc.
function bttn_trackvidfunc_Callback(hObject, eventdata, handles)
% hObject    handle to bttn_trackvidfunc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gh
% gh.param.batchNum = 2;
gh.param.batchNum = gh.param.batchNum + 1;
% while (gh.param.batchNum*round(gh.param.ChunkSize*gh.param.FrameRate))<=(gh.param.FrameRate*7200)
    tic
    set(gh.disp.textOverallProgress, 'String', ['Processing batch ' num2str(gh.param.batchNum)]);
    fhtrack_trackWholeExpt(gh.param.batchNum); 
%     gh.param.batchNum = gh.param.batchNum + 1;
    toc
% end


% --- Executes on button press in pb_resumetrack.
function pb_resumetrack_Callback(hObject, eventdata, handles)
global gh


% while (gh.param.batchNum*round(gh.param.ChunkSize*gh.param.FrameRate))<=(gh.param.FrameRate*7200)
    tic
    set(gh.disp.textOverallProgress, 'String', ['Resuming and tracking the current batch: ' num2str(gh.param.batchNum)]);
    fhtrack_trackWholeExpt_resumetrack(gh.param.batchNum); 
%     gh.param.batchNum = gh.param.batchNum + 1;
    toc
% end
% hObject    handle to pb_resumetrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
