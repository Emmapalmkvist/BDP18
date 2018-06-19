function handles = initialiseSliders(handles)
%INITIALISESLIDERS Initialiserer sliderne til Layer og ROIPicture
%   De parametre der indstilles er:
%   - Value, som er 1 og dermed der hvor silderne starter. 
%   - Minimuns-værdien hvilket er 1 da det er mindste værdi billederne har.
%   - Maksimums-værdien hvilket er antallet af snit i Layer og antallet af
%   billeder i et snit i ROIPicture.
%   - SliderStep, fortæller hvor langt slideren skal flyttes af gangen. 
%   INPUT:
%   handles: handle til elementer i gui
%
%   OUTPUT:
%   handles med indstillede værdier

%Initialiserer sliderROIPicture
 set(handles.SliderROIPicture, 'Value', 1);
 set(handles.SliderROIPicture, 'Min', 1); 
 set(handles.SliderROIPicture, 'Max', length(handles.MyData.Layers(1).Images)); 
 set(handles.SliderROIPicture, 'SliderStep', [1/length(handles.MyData.Layers(1).Images), 2/length(handles.MyData.Layers(1).Images)]);

%Initialiserer sliderLayer 
set(handles.SliderLayer, 'Value', 1);
set(handles.SliderLayer, 'Min', 1);
set(handles.SliderLayer, 'Max', handles.MyData.NumbOfLayers);
set(handles.SliderLayer, 'SliderStep', [1/(length(handles.MyData.Layers)-1), 2/(length(handles.MyData.Layers)-1)]);

end

