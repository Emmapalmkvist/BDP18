function displayROISonPicture(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


ImPos = get(handles.SliderLayer, 'Value');

 axes(handles.axDrawROI);
 value = length(handles.MyData.Layers(ImPos).ROIS(:));
for ii = 1:length(handles.MyData.Layers(ImPos).ROIS(:))

    if isfield(handles.MyData.Layers(ImPos).ROIS(ii).ROI,'Location')
        ROI = impoly(gca,handles.MyData.Layers(ImPos).ROIS(ii).ROI.Location);
        pos = handles.MyData.Layers(ImPos).ROIS(ii).ROI.Location;
        id = handles.MyData.Layers(ImPos).ROIS(ii).ROI.ROIID;
        text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on');
    else
          impoly;
    end
    
   
    
%     if ~isempty(handles.MyData.Layers(ImPos).ROIS)
%         idx = length(handles.MyData.Layers(ImPos).ROIS(:));
%     else
%         idx = 0
    %ROIpos = getPosition(ROI);
    %addNewPositionCallback(ROI,@(pos) calcFlow(handles,ROI,pos));
    %calcFlow(handles,ROI, ROIpos);
end 
end

