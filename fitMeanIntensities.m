function handles = fitMeanIntensities(handles)
%FITMEANINTENSITIES Fitter middelintensiteterne og udregner T2* derfra
%   Detailed explanation goes here


% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');

% Lav x-vektor
x = [handles.MyData.Layers(layerPos).Images.EchoTime]';
y = [handles.MyData.Layers(layerPos).ROIS(1).ROI.MeanValue]';

% Fit x og y-værdierne
f = fit(x, y, 'exp1');

handles.MyData.Layers(layerPos).ROIS(1).ROI.T2 = -1/f.b;


end

