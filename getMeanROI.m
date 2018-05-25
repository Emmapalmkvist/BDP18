function  y = getMeanROI(handles, mask)
%GETMEANROI Summary of this function goes here
%   Detailed explanation goes here

ImPos = get(handles.SliderROIPicture, 'Max');

layerPos = get(handles.SliderLayer, 'Value');
%       Pr�allokering
y = zeros(1, ImPos);

for i = 1:ImPos
    image = double(handles.MyData.Layers(layerPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    image(mask == 0) = 0;

    % Normalis�r billedet
    pic = image/max(image(:));

    % Tag middelv�rdi af v�rdierne i ROI'en
    y(i) = mean(pic(:));
    %handles.MyData.Layers(ImPos).ROIS.ROI1.mean(i) = y(i);
end
    y = y;
    %handles.MyData.Layers(ImPos).ROIS.ROI1.mean = y;
end

