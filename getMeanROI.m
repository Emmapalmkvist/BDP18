function  [y, echoPix] = getMeanROI(handles, mask)
%GETMEANROI Summary of this function goes here
%   Detailed explanation goes here

echoPos = get(handles.SliderROIPicture, 'Max');

layerPos = get(handles.SliderLayer, 'Value');
%       Præallokering
y = zeros(1, echoPos);
% Klargør struct til pixels signalintensiteter for hver echotime
echoPix = struct([]);

for i = 1:echoPos
    image = double(handles.MyData.Layers(layerPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    image(mask == 0) = 0;

    % Normalisér billedet
    pic = image/max(image(:));

    % Find indexes for punkterne i ROI'en
    idx = find(mask);
    
    % Få pixel intensiteterne for denne echotid
    intensity = pic(idx);
    
    % Tag middelværdi af værdierne i ROI'en
    y(i) = mean(pic(:));
    
    % --- TEST
    %echoPix(i).Pixels(:,1) = intensity(:);
    %echoPix(i).Pixels(:,2) = idx(:);
    
    %echoPix(i).Intensity(:) = cell2struct(intensity);
    %echoPix(i).Index = [idx];
    % --- TEST SLUT
    
    
    % I kolonne 1 placeres intensiteterne
    echoPix(i).Pixels(:,1) = intensity;
    % I kolonne placeres deres tilhørende placering/index
    echoPix(i).Pixels(:,2) = idx;
    %handles.MyData.Layers(ImPos).ROIS.ROI1.mean(i) = y(i);
end
    y = y;
    %handles.MyData.Layers(ImPos).ROIS.ROI1.mean = y;
end

