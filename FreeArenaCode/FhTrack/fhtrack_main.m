function varargout = fhtrack_main(varargin)
% FHTRACK_MAIN MATLAB code for fhtrack_main.fig
%      FHTRACK_MAIN, by itself, creates a new FHTRACK_MAIN or raises the existing
%      singleton*.
%
%      H = FHTRACK_MAIN returns the handle to a new FHTRACK_MAIN or the handle to
%      the existing singleton*.
%
%      FHTRACK_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FHTRACK_MAIN.M with the given input arguments.
%
%      FHTRACK_MAIN('Property','Value',...) creates a new FHTRACK_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fhtrack_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fhtrack_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fhtrack_main

% Last Modified by GUIDE v2.5 10-Apr-2018 23:50:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fhtrack_main_OpeningFcn, ...
                   'gui_OutputFcn',  @fhtrack_main_OutputFcn, ...
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


% --- Executes just before fhtrack_main is made visible.
function fhtrack_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fhtrack_main (see VARARGIN)

% Choose default command line output for fhtrack_main
handles.output = hObject;
fhtrack_addhandles('main',hObject);
fhtrack_initialization('main');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fhtrack_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fhtrack_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editRootDir_Callback(hObject, eventdata, handles)
% hObject    handle to editRootDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_editfunc(hObject);
% Hints: get(hObject,'String') returns contents of editRootDir as text
%        str2double(get(hObject,'String')) returns contents of editRootDir as a double


% --- Executes during object creation, after setting all properties.
function editRootDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRootDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_setRootDir;


function editExptDate_Callback(hObject, eventdata, handles)
% hObject    handle to editExptDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_editfunc(hObject);
% Hints: get(hObject,'String') returns contents of editExptDate as text
%        str2double(get(hObject,'String')) returns contents of editExptDate as a double


% --- Executes during object creation, after setting all properties.
function editExptDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editExptDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editExptIndex_Callback(hObject, eventdata, handles)
% hObject    handle to editExptIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_editfunc(hObject);
% Hints: get(hObject,'String') returns contents of editExptIndex as text
%        str2double(get(hObject,'String')) returns contents of editExptIndex as a double


% --- Executes during object creation, after setting all properties.
function editExptIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editExptIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bttnNextExpt.
function bttnNextExpt_Callback(hObject, eventdata, handles)
% hObject    handle to bttnNextExpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_bttnNextExpt;

% --- Executes on button press in bttnReset.
function bttnReset_Callback(hObject, eventdata, handles)
% hObject    handle to bttnReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bttnNextDate.
function bttnNextDate_Callback(hObject, eventdata, handles)
% hObject    handle to bttnNextDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in bttnLoadExpt.
function bttnLoadExpt_Callback(hObject, eventdata, handles)
% hObject    handle to bttnLoadExpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_getfilenamefunc;
tic;fhtrack_cvloadfunc(1);toc


function editChunkSize_Callback(hObject, eventdata, handles)
% hObject    handle to editChunkSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_editnumfunc(hObject);
% Hints: get(hObject,'String') returns contents of editChunkSize as text
%        str2double(get(hObject,'String')) returns contents of editChunkSize as a double


% --- Executes during object creation, after setting all properties.
function editChunkSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editChunkSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in toggVidData.
function toggVidData_Callback(hObject, eventdata, handles)
% hObject    handle to toggVidData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% fhtrack_togfunc(hObject);
% Hint: get(hObject,'Value') returns toggle state of toggVidData


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_savefunc;


function editFrameRate_Callback(hObject, eventdata, handles)
% hObject    handle to editFrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_editnumfunc(hObject);
% Hints: get(hObject,'String') returns contents of editFrameRate as text
%        str2double(get(hObject,'String')) returns contents of editFrameRate as a double


% --- Executes during object creation, after setting all properties.
function editFrameRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFrameRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bttnExptType.
function bttnExptType_Callback(hObject, eventdata, handles)
% hObject    handle to bttnExptType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_bttnExptType(hObject);



function editImHeight_Callback(hObject, eventdata, handles)
% hObject    handle to editImHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editImHeight as text
%        str2double(get(hObject,'String')) returns contents of editImHeight as a double


% --- Executes during object creation, after setting all properties.
function editImHeight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImHeight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editImWidth_Callback(hObject, eventdata, handles)
% hObject    handle to editImWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editImWidth as text
%        str2double(get(hObject,'String')) returns contents of editImWidth as a double


% --- Executes during object creation, after setting all properties.
function editImWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
