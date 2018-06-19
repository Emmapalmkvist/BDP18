function  [y, echoPix] = getMeanROI(handles, mask)
%GETMEANROI Beregner middelintensiteten af en ROI. 
%
%   INPUT:
%   handles: handle til elementer i gui
%   mask: maske for den ROI, som middelintensiteterne skal findes for
%
%   OUTPUT:
%   y: Middelværdierne for ROIen
%   echoPix:
%   - echoPix.Pixels: hver pixels intensitet, som kan bruges senere til
%     pixelvis analyse
%   - echoPix.Indexes: index på pixels i ROI'en

echoPos = get(handles.SliderROIPicture, 'Max');
layerPos = get(handles.SliderLayer, 'Value');

%Præallokering
y = zeros(1, echoPos);
% Klargør struct til pixels signalintensiteter for hver echotime
echoPix = struct([]);

for i = 1:echoPos
    im = double(handles.MyData.Layers(layerPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    im(mask == 0) = 0;
    %Alle de steder i masken der er 0, skal også være 0 i billedet
   
    % Find indexes for punkterne i ROI'en
    % Finder placering af alle 1'erne i masken 
    idx = find(mask);
    % Finder intensiteterne i billedet der hvor ROI'en er
    % Få pixel intensiteterne for denne echotid
    intensity = im(idx);
    % Tag middelværdi af værdierne i ROI'en
    y(i) = mean(im(idx));
    
    % Intensiteterne gemmes
    echoPix(i).Pixels = intensity;

end
     
    % Gem indexes
    echoPix(1).Indexes = idx;
end

