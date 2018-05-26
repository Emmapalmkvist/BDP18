function handles = excludePixels(handles, ROIID, boundary)
%EXCLUDEPIXELS Eksluderer dårligt fittede pixels ud fra de specificerede
%værdier
%   Detailed explanation goes here

% Find antallet af pixels i ROI'en (i det snit)
layerPos = get(handles.SliderLayer, 'Value');

% Find indexes på de værdier, som er større end eller lig den specificerede
% værdi
pixelIdx = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary);

% Hent T2-værdierne
T2s = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2];

% Sæt værdierne til 0 på idx-pladserne
T2s(pixelIdx) = 0;

% Kør colormapning
handles = colormapPixels(handles, ROIID, layerPos, T2s);

% Udregn gennemsnitlige T2*-værdi for resterende pixels
handles = fitMeanIntensities;
end

