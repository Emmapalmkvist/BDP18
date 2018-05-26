function handles = excludePixels(handles, ROIID, boundary)
%EXCLUDEPIXELS Eksluderer d�rligt fittede pixels ud fra de specificerede
%v�rdier
%   Detailed explanation goes here

% Find antallet af pixels i ROI'en (i det snit)
layerPos = get(handles.SliderLayer, 'Value');

% Find indexes p� de v�rdier, som er st�rre end eller lig den specificerede
% v�rdi
pixelIdx = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary);

% Hent T2-v�rdierne
T2s = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2];

% S�t v�rdierne til 0 p� idx-pladserne
T2s(pixelIdx) = 0;

% K�r colormapning
handles = colormapPixels(handles, ROIID, layerPos, T2s);

% Udregn gennemsnitlige T2*-v�rdi for resterende pixels
handles = fitMeanIntensities;
end

