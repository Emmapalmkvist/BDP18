function [handles,y] = getMeanROI(handles)
%GETMEANROI Summary of this function goes here
%   Detailed explanation goes here

mValue = get(handles.SliderROIPicture, 'Max');
%       Præallokering
y = zeros(1, mValue);

for i = 1:mValue
    image = double(handles.MyData.Layers(ImPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    image(mask == 0) = 0;

    % Normalisér billedet
    pic = image/max(image(:));

    % Tag middelværdi af værdierne i ROI'en
    y(i) = mean(pic(:));
 %   handles.MyData.Layers(ImPos).ROIS.ROI1.mean(i) = y(i);
end

end

