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

% Last Modified by GUIDE v2.5 27-May-2018 20:41:40

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

 handles = displayROIPicture(handles);
 guidata(hObject, handles);
 

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

handles = displayLayers(handles);
guidata(hObject, handles);
handles = clearAnalysis(handles);


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

layerPos = get(handles.SliderLayer, 'Value');
ROIidx = get(handles.lbT2Ana, 'Value');

 % Plot den tilhørende analyse (tjekker først, at der er en)
 if isfield(handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI, 'MeanValue')
     x = [handles.MyData.Layers(layerPos).Images.EchoTime]';
     y = [handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.MeanValue]';
     f = handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.FitData;
     axes(handles.axT2Graph);
     plot(f, x, y);
     set(get(handles.axT2Graph, 'ylabel'), 'string', 'Middelintensitet'); 
     set(get(handles.axT2Graph, 'xlabel'), 'string', 'Ekkotid');
     T2 = handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.T2;
     set(handles.txtT2, 'String', round(T2, 2));
 end


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


handles = initialiseSliders(handles);
guidata(hObject, handles);
handles = displayLayers(handles);
guidata(hObject, handles);

handles = displayROIPicture(handles);
guidata(hObject, handles);


% --------------------------------------------------------------------
function tbQuestion_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbQuestion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hjælp', 'Hjælp')
     return;

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

% Tjek om der er tegnet ROIs
if isfield(handles, 'MyData')
    if isfield(handles.MyData.Layers, 'ROIS')
        ROIID = get(handles.lbT2Ana, 'Value');
        handles = fitPixelIntensities(handles, ROIID);
        guidata(hObject, handles);
    else
        msgbox('Der er ingen ROI at udføre pixelvis analyse for.');
    end
else
    msgbox('Indlæs først billeder og vælg område at udføre analyse for.');
end



% --------------------------------------------------------------------
function uiSaveToLater_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiSaveToLater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SaveAnalysis(handles);


% --------------------------------------------------------------------
function tbLoadAnalysis_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to tbLoadAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadSavedAnalysis(handles);


% --- Executes on button press in btnExcludePlus.
function btnExcludePlus_Callback(hObject, eventdata, handles)
% hObject    handle to btnExcludePlus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Først findes max-værdien for typen af Goodness of Fit
layerPos = get(handles.SliderLayer, 'Value');
ROIID = get(handles.lbT2Ana, 'Value');
type = get(get(handles.btnGrpExclude,'SelectedObject'), 'String');

if(strcmp(type,'rmse'))
    % Hent max-værdien og afrund den til kun 1 decimal
    max = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxRMSE;
    plusValue = 0.1;
elseif(strcmp(type, 'R^2'))
    % Hent max-værdien og afrund den til 2 decimaler
    max = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxR2;
    plusValue = 0.01;
end

value = get(handles.etExcludePixels, 'String');
value = str2double(value);

value = value + plusValue;


if (value+plusValue) >= max
    set(handles.btnExcludePlus, 'enable', 'off');
else
    set(handles.etExcludePixels, 'String', num2str(value));
end
set(handles.btnExcludeMinus, 'enable', 'on');

% --- Executes on button press in btnExcludeMinus.
function btnExcludeMinus_Callback(hObject, eventdata, handles)
% hObject    handle to btnExcludeMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Først findes min-værdien for RMSE
layerPos = get(handles.SliderLayer, 'Value');
ROIID = get(handles.lbT2Ana, 'Value');
type = get(get(handles.btnGrpExclude,'SelectedObject'), 'String');

if(strcmp(type, 'rmse'))
    % Hent min-værdien og afrund den til kun 1 decimal
    min = round(handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinRMSE,1);
    minusValue = 0.1;
elseif(strcmp(type, 'R^2'))
    % Hent min-værdien og afrund den til 2 decimaler
    min = round(handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinR2,2);
    minusValue = 0.01;
end

value = get(handles.etExcludePixels, 'String');
value = str2double(value);
value = value - minusValue;

if (value-minusValue) <= min
    set(handles.btnExcludeMinus, 'enable', 'off');
else
    set(handles.etExcludePixels, 'String', num2str(value));
end
set(handles.btnExcludePlus, 'enable', 'on');


function etExcludePixels_Callback(hObject, eventdata, handles)
% hObject    handle to etExcludePixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etExcludePixels as text
%        str2double(get(hObject,'String')) returns contents of etExcludePixels as a double


% --- Executes during object creation, after setting all properties.
function etExcludePixels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etExcludePixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnExclude.
function btnExclude_Callback(hObject, eventdata, handles)
% hObject    handle to btnExclude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ROIID = get(handles.lbT2Ana, 'Value');
boundary = get(handles.etExcludePixels, 'String');
type = get(get(handles.btnGrpExclude,'SelectedObject'), 'String');
handles = excludePixels(handles, ROIID, type, str2double(boundary));
guidata(hObject, handles)


% --- Executes on button press in rbR2.
function rbR2_Callback(hObject, eventdata, handles)
% hObject    handle to rbR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbR2
layerPos = get(handles.SliderLayer, 'Value');
ROIID = get(handles.lbT2Ana, 'Value');
R2 = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxR2;
set(handles.etExcludePixels, 'String', num2str(round(R2,2)));
set(handles.txtHeaderExcl, 'String', sprintf('Ekskluder pixels med R^2\r\n mindre end:'));


% --- Executes on button press in rbRMSE.
function rbRMSE_Callback(hObject, eventdata, handles)
% hObject    handle to rbRMSE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbRMSE
layerPos = get(handles.SliderLayer, 'Value');
ROIID = get(handles.lbT2Ana, 'Value');
RMSE = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxRMSE;
set(handles.etExcludePixels, 'String', num2str(round(RMSE,1)));
set(handles.txtHeaderExcl, 'String', sprintf('Ekskluder pixels med RMSE\r\n større end:'));
