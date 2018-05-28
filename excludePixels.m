function handles = excludePixels(handles, ROIID, type, boundary)
%EXCLUDEPIXELS Eksluderer d�rligt fittede pixels ud fra de specificerede
%v�rdier

layerPos = get(handles.SliderLayer, 'Value');

% Tjek hvilken type v�rdi der er valgt at sortere efter: RMSE eller R^2
if(strcmp(type, 'rmse'))
    % Find placering af de v�rdier, som er st�rre end eller lig den specificerede v�rdi
    valueLoc = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary;
elseif(strcmp(type, 'R^2'))
    % Find placering af de v�rdier, som er st�rre end eller lig den specificerede v�rdi
    valueLoc = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare] >= boundary;
end

% Find placering af de v�rdier, som er st�rre end eller lig den specificerede
% v�rdi
%rmseLoc = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary);
%valueLoc = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary;


% Find deres tilh�rende index i billede
idx = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes;
% Fjern disse indexes
idx(valueLoc) = [];

% K�r colormapning
handles = colormapPixels(handles, ROIID, layerPos, idx);

% Lav en maske
mask = zeros(256,256);
mask(idx) = 1;

% F� gennemsnitsv�rdier for tilbagev�rende pixels
[y, ~] = getMeanROI(handles, mask);

% Udregn gennemsnitlige T2*-v�rdi for resterende pixels
handles = fitMeanIntensities(handles, ROIID, y);
end

