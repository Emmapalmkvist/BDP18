function handles = clearGUI(handles)
%CLEARGUI - clear GUI n�r nyt data indl�ses. 
%Derudover clear den alt det data der ligger i 'handles.MyData'


%Tjekker om MyData eksister, hvis den g�r det skal den slette indeholdet p�
%GUI
if isfield(handles, 'MyData')
    handles = rmfield(handles, 'MyData');
    cla(handles.axT2Graph); 
    cla(handles.axLayers);
    cla(handles.axDrawROI);
    handles.lbT2Ana.String = [];
    set(handles.txtT2,'String','');
    set(handles.txtPatient, 'String', '');
    set(handles.txtT2Revideret, 'String', '');
    (set(handles.SliderLayer,'value', 1));
    (set(handles.SliderROIPicture, 'value', 1));
    set(handles.txtSliderROIPicture, 'String', sprintf('%d/%d', 0, 0)); 
    set(handles.txtSliderLayer, 'String', sprintf('%d/%d', 0, 0)); 
end
end

