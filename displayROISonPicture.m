function ROI = displayROISonPicture(handles)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


ImPos = get(handles.SliderLayer, 'Value');

 axes(handles.axDrawROI);
 value = length(handles.MyData.Layers(ImPos).ROIS(:));
for ii = 1:length(handles.MyData.Layers(ImPos).ROIS(:))

    if isfield(handles.MyData.Layers(ImPos).ROIS(ii).ROI,'Location')
        ROI = impoly(gca,handles.MyData.Layers(ImPos).ROIS(ii).ROI.Location);
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

