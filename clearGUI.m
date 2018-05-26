function clearGUI(handles)
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
end

end

