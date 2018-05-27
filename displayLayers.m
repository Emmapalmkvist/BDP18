function handles = displayLayers(handles)
%DISPLAYLAYERS viser alle billederne i et samlet snit for det nuværende snit
%   Det snit der har den værdie slideren står på vises i axen. 
%   For at vise alle billederne er de samlet i et med montage

%Henter slider værdien og runder værdien op til nærmeste heltal. 
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
montage([handles.MyData.Stacks(layerPos).Stack], 'Size', [antalRaekker,4])

% Alle billederne tilhørende nuværende snit gemmes
    handles.MyData.Layers(layerPos).Images = cell2struct(dataCell, fNames, 1);
    
    numbOfPics = length(handles.MyData.T2([handles.MyData.T2.LayerNo]==layerPos));
    
    % Alle billederne i et lag løbes igennem
    for ii = 1:numbOfPics
        % Billedet hentes og normaliseres, for at gemmes i en stack
        im = double(handles.MyData.Layers(i).Images(ii).Image);
        im = im/max(im(:));
        handles.MyData.Stacks(i).Stack(:,:,1,ii) = im;
    end

% Kald displayROIPicture for at få det første echotime-billede vist
handles = displayROIPicture(handles);

%guidata(hObject, handles);
end