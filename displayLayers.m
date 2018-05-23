function handles = displayLayers(handles)
%DISPLAYLAYERS Viser montage af billederne i et lag i axes
%

%Henter slider v�rdien og runder v�rdien op til n�rmeste heltal. 
ImPos = ceil(get(handles.SliderLayer, 'Value'));
%S�tter teksten under slider, der fort�ller hvilket snit der bliver vist ud
%af x-antal i alt. 
set(handles.txtSliderLayer, 'String', sprintf('%d/%d',ImPos,length([handles.MyData.Layers])));

%Fort�ller hvor snit-billederne skal vises. 
axes(handles.axLayers)
%Der er altid 4 billeder pr. r�kke i montage. 
antalRaekker = length(handles.MyData.Layers(ImPos).Images)/4;
%Montage vise alle snitbillederne i et stort billede. 
%Strack(ImPos).Strack - fort�ller hvilken strack der skal bruges ud fra
%snitposisionen, og s� finder den alle billedern i det snit. 
montage([handles.MyData.Stacks(ImPos).Stack], 'Size', [antalRaekker,4])

%guidata(hObject, handles);
end

