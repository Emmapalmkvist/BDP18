function handles = clearAnalysis(handles)
%CLEARANALYSIS - clear flere elementer p� brugergr�nsefladen n�r der
%skiftes snit med slideren. 
cla(handles.axT2Graph); 
    handles.lbT2Ana.String = [];
    set(handles.txtT2,'String','');
    (set(handles.SliderROIPicture, 'value', 1));
    layerPos = ceil(get(handles.SliderLayer, 'Value'));
    set(handles.txtSliderROIPicture, 'String', sprintf('%d/%d', 1, length(handles.MyData.Layers(layerPos).Images)));
end

