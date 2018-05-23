function handles = displayLayers(handles)
%DISPLAYLAYERS Viser montage af billederne i et lag i axes
%

%Henter slider værdien og runder værdien op til nærmeste heltal. 
ImPos = ceil(get(handles.SliderLayer, 'Value'));
%Sætter teksten under slider, der fortæller hvilket snit der bliver vist ud
%af x-antal i alt. 
set(handles.txtSliderLayer, 'String', sprintf('%d/%d',ImPos,length([handles.MyData.Layers])));

%Fortæller hvor snit-billederne skal vises. 
axes(handles.axLayers)
%Der er altid 4 billeder pr. række i montage. 
antalRaekker = length(handles.MyData.Layers(ImPos).Images)/4;
%Montage vise alle snitbillederne i et stort billede. 
%Strack(ImPos).Strack - fortæller hvilken strack der skal bruges ud fra
%snitposisionen, og så finder den alle billedern i det snit. 
montage([handles.MyData.Stacks(ImPos).Stack], 'Size', [antalRaekker,4])

%guidata(hObject, handles);
end

