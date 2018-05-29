function handles = clearAnalysis(handles, ~)
%CLEARANALYSIS clearer flere elementer på brugergrænsefladen når der
%skiftes snit med slideren.
%   Det 2. inputargument giver udtryk for, om der skal cleares pga. et
%   skift af snit

if nargin == 2
    handles.lbT2Ana.String = [];
end

cla(handles.axT2Graph);
set(handles.txtT2,'String','');
(set(handles.SliderROIPicture, 'value', 1));
layerPos = ceil(get(handles.SliderLayer, 'Value'));
set(handles.txtSliderROIPicture, 'String', sprintf('%d/%d', 1, length(handles.MyData.Layers(layerPos).Images)));

set(handles.txtT2Revideret,'String','');
set(handles.etExcludePixels, 'String', '-');
set(findall(handles.GroupChoices, '-property', 'enable'), 'enable', 'off');
end

