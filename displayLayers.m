function handles = displayLayers(handles)
%DISPLAYLAYERS viser alle billederne i et samlet snit for det nuv�rende snit
%   Det snit der har den v�rdie slideren st�r p� vises i axen. 
%   For at vise alle billederne er de samlet i et med montage

%Henter slider v�rdien og runder v�rdien op til n�rmeste heltal. 
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
montage([handles.MyData.Stacks(layerPos).Stack], 'Size', [antalRaekker,4])

% Alle billederne tilh�rende nuv�rende snit gemmes
    handles.MyData.Layers(layerPos).Images = cell2struct(dataCell, fNames, 1);
    
    numbOfPics = length(handles.MyData.T2([handles.MyData.T2.LayerNo]==layerPos));
    
    % Alle billederne i et lag l�bes igennem
    for ii = 1:numbOfPics
        % Billedet hentes og normaliseres, for at gemmes i en stack
        im = double(handles.MyData.Layers(i).Images(ii).Image);
        im = im/max(im(:));
        handles.MyData.Stacks(i).Stack(:,:,1,ii) = im;
    end

% Kald displayROIPicture for at f� det f�rste echotime-billede vist
handles = displayROIPicture(handles);

%guidata(hObject, handles);
end