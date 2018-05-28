function  [y, echoPix] = getMeanROI(handles, mask)
%GETMEANROI Beregner middelintensiteten af en ROI. 

echoPos = get(handles.SliderROIPicture, 'Max');
layerPos = get(handles.SliderLayer, 'Value');

%Pr�allokering
y = zeros(1, echoPos);
% Klarg�r struct til pixels signalintensiteter for hver echotime
echoPix = struct([]);

for i = 1:echoPos
    im = double(handles.MyData.Layers(layerPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    im(mask == 0) = 0;
   
    % Find indexes for punkterne i ROI'en
    idx = find(mask);
    % F� pixel intensiteterne for denne echotid
    intensity = im(idx);
    % Tag middelv�rdi af v�rdierne i ROI'en
    y(i) = mean(im(idx));
    
    % Intensiteterne gemmes
    echoPix(i).Pixels = intensity;

end
     
    % Gem indexes
    echoPix(1).Indexes = idx;
end

