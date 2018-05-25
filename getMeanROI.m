function [handles,y] = getMeanROI(handles)
%GETMEANROI Summary of this function goes here
%   Detailed explanation goes here

mValue = get(handles.SliderROIPicture, 'Max');
%       Pr�allokering
y = zeros(1, mValue);

for i = 1:mValue
    image = double(handles.MyData.Layers(ImPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    image(mask == 0) = 0;

    % Normalis�r billedet
    pic = image/max(image(:));

    % Tag middelv�rdi af v�rdierne i ROI'en
    y(i) = mean(pic(:));
 %   handles.MyData.Layers(ImPos).ROIS.ROI1.mean(i) = y(i);
end

end

