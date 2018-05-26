function handles = excludePixels(handles, ROIID, boundary)
%EXCLUDEPIXELS Eksluderer dårligt fittede pixels ud fra de specificerede
%værdier
%   Detailed explanation goes here

layerPos = get(handles.SliderLayer, 'Value');

% Find placering af de værdier, som er større end eller lig den specificerede
% værdi
rmseLoc = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary);
% Find deres tilhørende index i billede
idx = handles.MyData.Layers(1).ROIS.ROI.EchoPix(1).Indexes;
idx(rmseLoc) = [];

% Hent T2-værdierne
%T2s = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2];

% Sæt værdierne til 0 på idx-pladserne
%T2s(rmseLoc) = 0;

% Kør colormapning
handles = colormapPixels(handles, ROIID, layerPos, idx);

% Lav en maske
mask = zeros(256,256);
mask(idx) = 1;

% Få gennemsnitsværdier for tilbageværende pixels
[y, ~] = getMeanROI(handles, mask);

% Udregn gennemsnitlige T2*-værdi for resterende pixels
handles = fitMeanIntensities(handles, ROIID, y);
end

