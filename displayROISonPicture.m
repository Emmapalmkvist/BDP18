function displayROISonPicture(handles)
%DISPLAYROISONPICTURE Summary of this function goes here
%   Detailed explanation goes here

%Denne funktion s�rger for, at n�r der tegnet en ROI p� et af billederne i
%et snit, s� f�lger ROIen med n�r der skiftes billede p� slideren.

layerPos = get(handles.SliderLayer, 'Value');

axes(handles.axDrawROI);
value = length(handles.MyData.Layers(ImPos).ROIS(:));
for ii = 1:length(handles.MyData.Layers(ImPos).ROIS(:))
    
    for ii = 1:length(handles.MyData.Layers(layerPos).ROIS(:))
        
        if isfield(handles.MyData.Layers(layerPos).ROIS(ii).ROI,'Location')
            %gca = getcurrentaxes
            impoly(gca,handles.MyData.Layers(layerPos).ROIS(ii).ROI.Location);
            pos = handles.MyData.Layers(layerPos).ROIS(ii).ROI.Location;
            id = handles.MyData.Layers(layerPos).ROIS(ii).ROI.ROIID;
            text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on');
        else
            return;
        end
    end
end

