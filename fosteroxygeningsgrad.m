function varargout = fosteroxygeningsgrad(varargin)
% FOSTEROXYGENINGSGRAD MATLAB code for fosteroxygeningsgrad.fig
%      FOSTEROXYGENINGSGRAD, by itself, creates a new FOSTEROXYGENINGSGRAD or raises the existing
%      singleton*.
%
%      H = FOSTEROXYGENINGSGRAD returns the handle to a new FOSTEROXYGENINGSGRAD or the handle to
%      the existing singleton*.
%
%      FOSTEROXYGENINGSGRAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOSTEROXYGENINGSGRAD.M with the given input arguments.
%
%      FOSTEROXYGENINGSGRAD('Property','Value',...) creates a new FOSTEROXYGENINGSGRAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fosteroxygeningsgrad_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fosteroxygeningsgrad_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fosteroxygeningsgrad

% Last Modified by GUIDE v2.5 26-May-2018 13:44:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fosteroxygeningsgrad_OpeningFcn, ...
                   'gui_OutputFcn',  @fosteroxygeningsgrad_OutputFcn, ...
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


% --- Executes just before fosteroxygeningsgrad is made visible.
function fosteroxygeningsgrad_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fosteroxygeningsgrad (see VARARGIN)

% Choose default command line output for fosteroxygeningsgrad
handles.output = hObject;
axes(handles.axLogo)
imshow('LogoAarhusUni.jpg');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fosteroxygeningsgrad wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fosteroxygeningsgrad_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function SliderROIPicture_Callback(hObject, eventdata, handles)
% hObject    handle to SliderROIPicture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

 displayROIPicture(handles);

% --- Executes during object creation, after setting all properties.
function SliderROIPicture_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderROIPicture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function SliderLayer_Callback(hObject, eventdata, handles)
% hObject    handle to SliderLayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

displayLayers(handles);



% --- Executes during object creation, after setting all properties.
function SliderLayer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderLayer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on selection change in lbT2Ana.
function lbT2Ana_Callback(hObject, eventdata, handles)
% hObject    handle to lbT2Ana (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbT2Ana contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbT2Ana
handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lbT2Ana_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbT2Ana (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnLoadImages.
function btnLoadImages_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = loadFiles(handles);
guidata(hObject, handles);
handles = sortLayers(handles);
guidata(hObject, handles);


initialisererSliders(handles);
guidata(hObject, handles);
displayLayers(handles);
guidata(hObject, handles);

displayROIPicture(handles);
guidata(hObject, handles);


% --- Executes on button press in btnDrawROI.
function btnDrawROI_Callback(hObject, eventdata, handles)
% hObject    handle to btnDrawROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btnSave.
function btnSave_Callback(hObject, eventdata, handles)
% hObject    handle to btnSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --------------------------------------------------------------------
function tbDrawROI_OnCallback(hObject, eventdata, handles)
% hObject    handle to tbDrawROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = CreateROIs(handles);
guidata(hObject, handles);



% --------------------------------------------------------------------
function tbOpen_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = loadFiles(handles);
guidata(hObject, handles);
handles = sortLayers(handles);
guidata(hObject, handles);


initialisererSliders(handles);
guidata(hObject, handles);
displayLayers(handles);
guidata(hObject, handles);

displayROIPicture(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function tbQuestion_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbQuestion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function tbSave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SaveResults(handles);


% --------------------------------------------------------------------
function tbFitPixels_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbFitPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ROIID = get(handles.lbT2Ana, 'Value');
handles = fitPixelIntensities(handles, ROIID);
guidata(hObject, handles);


% --------------------------------------------------------------------
function uiSaveToLater_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiSaveToLater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SaveResults(handles);
