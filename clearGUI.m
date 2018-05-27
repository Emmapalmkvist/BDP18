function handles = clearGUI(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Tjekker om MyData eksister, hvis den gør det skal den slette indeholdet på
%GUI
if isfield(handles, 'MyData')
    handles = rmfield(handles, 'MyData');
    cla(handles.axT2Graph); 
    cla(handles.axLayers);
    cla(handles.axDrawROI);
    handles.lbT2Ana.String = [];
    set(handles.txtT2,'String','');
    set(handles.txtPatient, 'String', '');
    %set(handles.txtT2reviderett, 'String', '');
    (set(handles.SliderLayer,'value', 1));
    (set(handles.SliderROIPicture, 'value', 1));
    set(handles.txtSliderROIPicture, 'String', sprintf('%d/%d', 0, 0)); 
    set(handles.txtSliderLayer, 'String', sprintf('%d/%d', 0, 0)); 
end

end

