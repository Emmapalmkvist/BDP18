function handles = initialiseSliders(handles)
%INITIALISESLIDERS Initialiserer sliderne til Layer og ROIPicture
%   De parametre der indstilles er:
%   - Value, som er 1 og dermed der hvor silderne starter. 
%   - Minimuns-v�rdien hvilket er 1 da det er mindste v�rdi billederne har.
%   - Maksimums-v�rdien hvilket er antallet af snit i Layer og antallet af
%   billeder i et snit i ROIPicture.
%   - SliderStep, fort�ller hvor langt slideren skal flyttes af gangen. 
%   INPUT:
%   handles: handle til elementer i gui
%
%   OUTPUT:
%   handles med indstillede v�rdier

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
%Der tr�kkes 1 fra, fordi der kun skal v�re 4 step og ikke 5 da den stater
%i et. 
    %S�dan burde det ogs� have v�ret i sliderROIPicture, her er nemlig 16
    %step i stedet for 15 og billede 9 vises to gange. 
end

