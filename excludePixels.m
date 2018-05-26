function handles = excludePixels(handles, ROIID, boundary)
%EXCLUDEPIXELS Eksluderer d�rligt fittede pixels ud fra de specificerede
%v�rdier
%   Detailed explanation goes here

layerPos = get(handles.SliderLayer, 'Value');

% Find placering af de v�rdier, som er st�rre end eller lig den specificerede
% v�rdi
rmseLoc = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary);
% Find deres tilh�rende index i billede
idx = handles.MyData.Layers(1).ROIS.ROI.EchoPix(1).Indexes;
idx(rmseLoc) = [];

% Hent T2-v�rdierne
%T2s = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2];

% S�t v�rdierne til 0 p� idx-pladserne
%T2s(rmseLoc) = 0;

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

