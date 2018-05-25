function [handles, mask] = CreateROIs(handles, y)
axes(handles.axDrawROI);            % Udvælgelse af axes der kan tegnes på.

% Tjekker om handles indeholde MyData eller om MyData er tom og 
% notificerer med messagebox og returnerer fra
% funktionen, hvis det er tilfældet.
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Indlæs venligst billede');
    return;
end    

ImPos = get(handles.SliderLayer, 'Value');

% Tegn ROI
ROI = impoly;
ROI.Deletable = 0; 
pos = getPosition(ROI);

% Lav maske ud fra ROI
mask = ROI.createMask;

[y, echoPix] = getMeanROI(handles, mask);

if isfield(handles.MyData.Layers, 'ROIS')

    if ~isempty(handles.MyData.Layers(ImPos).ROIS)
        idx = length(handles.MyData.Layers(ImPos).ROIS(:));
    else
        idx = 0; 
    end
    
        id = ['ROI' num2str(idx+1)];                                      % id genereres
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).ROIID = id; % id sættes
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).Location = pos;  % Location sættes
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).MeanValue = y;
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).EchoPix = echoPix;
   
        oldList = get(handles.lbT2Ana, 'String');
        newList = strvcat(char(oldList), char(handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).ROIID));
        set(handles.lbT2Ana, 'String', newList);
     
    
    else 
    id = ['ROI' num2str(1)];          % id genereres                                      
        handles.MyData.Layers(ImPos).ROIS.ROI(1).ROIID = id; % id sættes
        handles.MyData.Layers(ImPos).ROIS.ROI(1).Location = pos;         
        handles.MyData.Layers(ImPos).ROIS.ROI(1).MeanValue = y;
        handles.MyData.Layers(ImPos).ROIS.ROI(1).EchoPix = echoPix;
        
        set(handles.lbT2Ana, 'String', {handles.MyData.Layers(ImPos).ROIS.ROI(1).ROIID});
end 


 end

