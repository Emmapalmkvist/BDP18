function  [y, echoPix] = getMeanROI(handles, mask)
%GETMEANROI Summary of this function goes here
%   Detailed explanation goes here

echoPos = get(handles.SliderROIPicture, 'Max');

layerPos = get(handles.SliderLayer, 'Value');
%       Pr�allokering
y = zeros(1, echoPos);
% Klarg�r struct til pixels signalintensiteter for hver echotime
echoPix = struct([]);

for i = 1:echoPos
    im = double(handles.MyData.Layers(layerPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    im(mask == 0) = 0;

    % Normalis�r billedet
    pic = im/max(im(:));

    % Find indexes for punkterne i ROI'en
    idx = find(mask);
    
    % F� pixel intensiteterne for denne echotid
    intensity = pic(idx);
    
    % Tag middelv�rdi af v�rdierne i ROI'en
    y(i) = mean(pic(idx));
    
    % --- TEST
    %echoPix(i).Pixels(:,1) = intensity(:);
    %echoPix(i).Pixels(:,2) = idx(:);
    
    %echoPix(i).Intensity(:) = cell2struct(intensity);
    %echoPix(i).Index = [idx];
    % --- TEST SLUT
    
    
    % Intensiteterne gemmes
    echoPix(i).Pixels = intensity;
    
    %handles.MyData.Layers(ImPos).ROIS.ROI1.mean(i) = y(i);
end

    % Gem indexes
    echoPix(1).Indexes = idx;
    %y = y;
    %handles.MyData.Layers(ImPos).ROIS.ROI1.mean = y;
end

