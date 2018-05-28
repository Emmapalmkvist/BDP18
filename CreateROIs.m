function [handles, mask] = CreateROIs(handles, y)

%CreateROIs giver brugeren mulighed for at markere en eller flere ROIs et MR-billede.
% Hver gang der bliver tegnet en ROI p� billedet indtaster brugeren et navn p� ROI�en,
%som bliver opdateret i listboxen og som en label p� billedet.
%Derudover bliver der hver gang der bliver tegnet en ROI gemt i handles med
%navnet, middelv�rdien, ekkotiden og positionen.

axes(handles.axDrawROI);            % Udv�lgelse af axes der kan tegnes p�.

% Tjekker om handles indeholde MyData eller om MyData er tom og
% notificerer med messagebox og returnerer fra
% funktionen, hvis det er tilf�ldet.
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Indl�s venligst billeder');
    return;
end

% Tegn ROI
ROI = impoly;

% Hvis ROI'en er blevet tegner (ESC er ikke trykket), s� skal nedenst�ende
% udf�res
if ~isempty(ROI)
    
    % 1 for en linje tekst
    ROInavn = inputdlg('Indtast navn p� ROI (v�vstype)', 'Navn p� ROI', 1, {'Hjerte'});
    
    % Tjekker om man har indtastet et navn p� ROI'en
    if ~isempty(ROInavn)
        pos = getPosition(ROI);
        
        layerPos = get(handles.SliderLayer, 'Value');
        h_Im = handles.MyData.HandleToCurrentROIImage;
        
        % Lav maske ud fra ROI
        mask = createMask(ROI, h_Im);
        
        [y, echoPix] = getMeanROI(handles, mask);
        
        if isfield(handles.MyData.Layers, 'ROIS')
            
            if ~isempty(handles.MyData.Layers(layerPos).ROIS)
                idx = length(handles.MyData.Layers(layerPos).ROIS(:));
            else
                idx = 0;
            end
            id = ROInavn;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).ROIID = id;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).Mask = mask;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).Location = pos;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).MeanValue = y;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).EchoPix = echoPix;
            
            set(handles.lbT2Ana, 'Enable', 'on');
            oldList = get(handles.lbT2Ana, 'String');
            newList = strvcat(char(oldList), char(handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).ROIID));
            set(handles.lbT2Ana, 'String', newList);
            % S�rger for, at den senest tegnede ROI er markeret i listboksen
            set(handles.lbT2Ana, 'Value', idx+1);
            
            
            text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on');
            
            handles = fitMeanIntensities(handles, idx+1);
        else
            
            id = ROInavn;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).ROIID = id;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).Mask = mask;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).Location = pos;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).MeanValue = y;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).EchoPix = echoPix;
            
            text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on')
            
            set(handles.GroupT2Ana, 'Visible', 'on');
            set(handles.GroupChoices, 'Visible', 'on');
            set(handles.lbT2Ana, 'String', {convertCharsToStrings(handles.MyData.Layers(layerPos).ROIS.ROI(1).ROIID)});
            handles = fitMeanIntensities(handles, 1);
        end
    else
        delete(ROI);
    end
end

end

