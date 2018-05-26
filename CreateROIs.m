function [handles, mask] = CreateROIs(handles, y)
axes(handles.axDrawROI);            % Udvælgelse af axes der kan tegnes på.

% Tjekker om handles indeholde MyData eller om MyData er tom og 
% notificerer med messagebox og returnerer fra
% funktionen, hvis det er tilfældet.
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Indlæs venligst billeder');
    return;
end    

% Tegn ROI
ROI = impoly;

% Hvis ROI'en er blevet tegner (ESC er ikke trykket), så skal nedenstående
% udføres
if ~isempty(ROI)
%ROI.Deletable = 1; 
pos = getPosition(ROI);

ImPos = get(handles.SliderLayer, 'Value');
h_Im = handles.MyData.HandleToCurrentROIImage;

% Lav maske ud fra ROI
mask = createMask(ROI, h_Im);

[y, echoPix] = getMeanROI(handles, mask);

if isfield(handles.MyData.Layers, 'ROIS')

    if ~isempty(handles.MyData.Layers(ImPos).ROIS)
        idx = length(handles.MyData.Layers(ImPos).ROIS(:));
    else
        idx = 0; 
    end
        ROInavn = inputdlg('Indtast navn på ROI (vævstype)', 'Navn på ROI', 1, {'Hjerte'});
        id = ROInavn;                                      % id genereres
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).ROIID = id; % id sættes
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).Mask = mask;
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).Location = pos;  % Location sættes
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).MeanValue = y;
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).EchoPix = echoPix;
   
        oldList = get(handles.lbT2Ana, 'String');
        newList = strvcat(char(oldList), char(handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).ROIID));
        set(handles.lbT2Ana, 'String', newList);
        % Sørg for, at den senest tegnede ROI er markeret i listboksen
        set(handles.lbT2Ana, 'Value', idx+1);
        handles = fitMeanIntensities(handles, idx+1, y);
    
else
    ROInavn = inputdlg('Indtast navn på ROI (vævstype)', 'Navn på ROI', 1, {'Hjerte'});
    
    %ROInavn = msgbox(sprintf('Indtast navn på ROI(vævstype): %s' , ROIpaanavn));
    id = ROInavn;          % id genereres                                      
        handles.MyData.Layers(ImPos).ROIS.ROI(1).ROIID = id; % id sættes
        handles.MyData.Layers(ImPos).ROIS.ROI(1).Mask = mask;
        handles.MyData.Layers(ImPos).ROIS.ROI(1).Location = pos;         
        handles.MyData.Layers(ImPos).ROIS.ROI(1).MeanValue = y;
        handles.MyData.Layers(ImPos).ROIS.ROI(1).EchoPix = echoPix;
        
        set(handles.GroupT2Ana, 'Visible', 'on');
        set(handles.GruoupChoices, 'Visible', 'on');
        set(handles.lbT2Ana, 'String', {convertCharsToStrings(handles.MyData.Layers(ImPos).ROIS.ROI(1).ROIID)});
        handles = fitMeanIntensities(handles, 1, y);
        
        %text((handles.MyData.Layers(ImPos).ROIS.ROI(1).Location(1,1)), (handles.MyData.Layers(ImPos).ROIS.ROI(1).Location(1,2)), sprintf('ROI'), 'color', [0.7 0.7 0]);
%        position = [(handles.MyData.Layers(ImPos).ROIS.ROI(1).Location(1,1)),(handles.MyData.Layers(ImPos).ROIS.ROI(1).Location(1,2))]
%        RGB = insertText((handles.MyData.T2(ImPos).Image), position, 'ROI', 'AnchorPoint','LeftBottom');
%        axes(handles.axDrawROI)
%        handles.MyData.HandleToCurrentROIImage = imshow(RGB);
%        imshow(RGB);
       
end 

end

end

