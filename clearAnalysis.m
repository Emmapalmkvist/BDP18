function handles = clearAnalysis(handles)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
cla(handles.axT2Graph); 
    handles.lbT2Ana.String = [];
    set(handles.txtT2,'String','');
    (set(handles.SliderROIPicture, 'value', 1));
    ImPos = ceil(get(handles.SliderLayer, 'Value'));
    set(handles.txtSliderROIPicture, 'String', sprintf('%d/%d', 1, length(handles.MyData.Layers(ImPos).Images)));
%    
end

