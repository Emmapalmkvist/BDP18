function handles = displayLayers(handles)
%DISPLAYLAYERS viser alle billederne i et samlet snit for det nuværende snit
%   Det snit der har den værdie slideren står på vises i axen.
%   For at vise alle billederne er de samlet i et med montage
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   handles med nye værdier fra funktionen displayROIPicture

%Henter slider værdien og runder værdien op til nærmeste heltal.
%ceil runder op til næste heltal, da get kan give kommatal. 
layerPos = ceil(get(handles.SliderLayer, 'Value'));
%Sætter teksten under slider, der fortæller hvilket snit der bliver vist ud
%af x-antal i alt.
set(handles.txtSliderLayer, 'String', sprintf('%d/%d',layerPos,length([handles.MyData.Layers])));

%Fortæller hvor snit-billederne skal vises.
axes(handles.axLayers)
%Der er altid 4 billeder pr. række i montage.
antalRaekker = length(handles.MyData.Layers(layerPos).Images)/4;
%Montage vise alle snitbillederne i et stort billede.
%Strack(ImPos).Strack - fortæller hvilken strack der skal bruges ud fra
%snitposisionen, og så finder den alle billedern i det snit.
montage([handles.MyData.Layers(layerPos).Stack], 'Size', [antalRaekker,4])

% Kald displayROIPicture for at få det første echotime-billede vist
handles = displayROIPicture(handles);


end
