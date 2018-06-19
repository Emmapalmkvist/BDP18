function handles = displayLayers(handles)
%DISPLAYLAYERS viser alle billederne i et samlet snit for det nuv�rende snit
%   Det snit der har den v�rdie slideren st�r p� vises i axen.
%   For at vise alle billederne er de samlet i et med montage
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   handles med nye v�rdier fra funktionen displayROIPicture

%Henter slider v�rdien og runder v�rdien op til n�rmeste heltal.
%ceil runder op til n�ste heltal, da get kan give kommatal. 
layerPos = ceil(get(handles.SliderLayer, 'Value'));
%S�tter teksten under slider, der fort�ller hvilket snit der bliver vist ud
%af x-antal i alt.
set(handles.txtSliderLayer, 'String', sprintf('%d/%d',layerPos,length([handles.MyData.Layers])));

%Fort�ller hvor snit-billederne skal vises.
axes(handles.axLayers)
%Der er altid 4 billeder pr. r�kke i montage.
antalRaekker = length(handles.MyData.Layers(layerPos).Images)/4;
%Montage vise alle snitbillederne i et stort billede.
%Strack(ImPos).Strack - fort�ller hvilken strack der skal bruges ud fra
%snitposisionen, og s� finder den alle billedern i det snit.
montage([handles.MyData.Layers(layerPos).Stack], 'Size', [antalRaekker,4])

% Kald displayROIPicture for at f� det f�rste echotime-billede vist
handles = displayROIPicture(handles);


end
