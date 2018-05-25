function  [y, echoPix] = getMeanROI(handles, mask)
%GETMEANROI Summary of this function goes here
%   Detailed explanation goes here

ImPos = get(handles.SliderROIPicture, 'Max');

layerPos = get(handles.SliderLayer, 'Value');
%       Pr�allokering
y = zeros(1, ImPos);
% Klarg�r struct til pixels signalintensiteter for hver echotime
echoPix = struct([]);

for i = 1:ImPos
    image = double(handles.MyData.Layers(layerPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    image(mask == 0) = 0;

    % Normalis�r billedet
    pic = image/max(image(:));

    % F� pixel intensiteterne for denne echotid
    intensity = pic(mask);
    
    % Tag middelv�rdi af v�rdierne i ROI'en
    y(i) = mean(pic(:));
    echoPix(i).Pixels = intensity;
    %handles.MyData.Layers(ImPos).ROIS.ROI1.mean(i) = y(i);
end
    y = y;
    %handles.MyData.Layers(ImPos).ROIS.ROI1.mean = y;
end

