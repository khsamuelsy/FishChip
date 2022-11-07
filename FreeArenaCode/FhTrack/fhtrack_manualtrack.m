function varargout = fhtrack_manualtrack(varargin)
% FHTRACK_MANUALTRACK MATLAB code for fhtrack_manualtrack.fig
%      FHTRACK_MANUALTRACK, by itself, creates a new FHTRACK_MANUALTRACK or raises the existing
%      singleton*.
%
%      H = FHTRACK_MANUALTRACK returns the handle to a new FHTRACK_MANUALTRACK or the handle to
%      the existing singleton*.
%
%      FHTRACK_MANUALTRACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FHTRACK_MANUALTRACK.M with the given input arguments.
%
%      FHTRACK_MANUALTRACK('Property','Value',...) creates a new FHTRACK_MANUALTRACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fhtrack_manualtrack_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fhtrack_manualtrack_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fhtrack_manualtrack

% Last Modified by GUIDE v2.5 22-Apr-2018 23:07:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fhtrack_manualtrack_OpeningFcn, ...
                   'gui_OutputFcn',  @fhtrack_manualtrack_OutputFcn, ...
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


% --- Executes just before fhtrack_manualtrack is made visible.
function fhtrack_manualtrack_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fhtrack_manualtrack (see VARARGIN)

% Choose default command line output for fhtrack_manualtrack
handles.output = hObject;

fhtrack_addhandles('manualtrack',hObject);
fhtrack_initialization('manualtrack');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fhtrack_manualtrack wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fhtrack_manualtrack_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ChckbxDeleteFhCoor.
function ChckbxDeleteFhCoor_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxDeleteFhCoor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_chckbxfunc('manualtrack',hObject);
% Hint: get(hObject,'Value') returns toggle state of ChckbxDeleteFhCoor


% --- Executes on button press in ChckbxManualTrack.
function ChckbxManualTrack_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxManualTrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_chckbxfunc('manualtrack',hObject);
% Hint: get(hObject,'Value') returns toggle state of ChckbxManualTrack



function EditNumFrameApply_Callback(hObject, eventdata, handles)
% hObject    handle to EditNumFrameApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gh
gh.param.nFrameApply = round(str2double(get(hObject,'String')));
set(hObject,'String',num2str(gh.param.nFrameApply));
% Hints: get(hObject,'String') returns contents of EditNumFrameApply as text
%        str2double(get(hObject,'String')) returns contents of EditNumFrameApply as a double


% --- Executes during object creation, after setting all properties.
function EditNumFrameApply_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditNumFrameApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bttnTrackModified.
function bttnTrackModified_Callback(hObject, eventdata, handles)
% hObject    handle to bttnTrackModified (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gh
FhIdx = gh.param.CurrentFhIdx;
if sum(gh.param.fhDeleteIdx == FhIdx) == 0
    IdxTemp = find(gh.data.FhCoor{1,FhIdx}(:,1)>0,1,'last');
    if IdxTemp < size(gh.data.ImRaw,3)
        set(gh.disp.textTrackProgress,'String',['Re-tracking fish ' num2str(FhIdx)]);
        fhtrack_trackv10b(FhIdx, IdxTemp + 1, gh.param.batchNum);
    end
end

set(gh.disp.textTrackProgress,'String','');
fhtrack_alert1;
fhtrack_playframes;
fhtrack_flagpotentiallosttrack;





% --- Executes on button press in ChckbxDeleteFish.
function ChckbxDeleteFish_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxDeleteFish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_chckbxfunc('manualtrack',hObject);
% Hint: get(hObject,'Value') returns toggle state of ChckbxDeleteFish



function TextCurrentFhIdx_Callback(hObject, eventdata, handles)
% hObject    handle to TextCurrentFhIdx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gh
gh.param.CurrentFhIdx = str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of TextCurrentFhIdx as text
%        str2double(get(hObject,'String')) returns contents of TextCurrentFhIdx as a double


% --- Executes on button press in bttnSwapTraj.
function bttnSwapTraj_Callback(hObject, eventdata, handles)
% hObject    handle to bttnSwapTraj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_swaptrajfunc;


function EditSwapIdxA_Callback(hObject, eventdata, handles)
% hObject    handle to EditSwapIdxA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditSwapIdxA as text
%        str2double(get(hObject,'String')) returns contents of EditSwapIdxA as a double


% --- Executes during object creation, after setting all properties.
function EditSwapIdxA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditSwapIdxA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditSwapIdxB_Callback(hObject, eventdata, handles)
% hObject    handle to EditSwapIdxB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditSwapIdxB as text
%        str2double(get(hObject,'String')) returns contents of EditSwapIdxB as a double


% --- Executes during object creation, after setting all properties.
function EditSwapIdxB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditSwapIdxB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditSwapStartFrame_Callback(hObject, eventdata, handles)
% hObject    handle to EditSwapStartFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EditSwapStartFrame as text
%        str2double(get(hObject,'String')) returns contents of EditSwapStartFrame as a double


% --- Executes during object creation, after setting all properties.
function EditSwapStartFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditSwapStartFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ChckbxPickFh.
function ChckbxPickFh_Callback(hObject, eventdata, handles)
% hObject    handle to ChckbxPickFh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fhtrack_chckbxfunc('manualtrack',hObject);
% Hint: get(hObject,'Value') returns toggle state of ChckbxPickFh
