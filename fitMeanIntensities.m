function handles = fitMeanIntensities(handles)
%FITMEANINTENSITIES Fitter middelintensiteterne og udregner T2* derfra
%   Detailed explanation goes here

wb = waitbar(0, 'Beregner T2*');
% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');

% Lav x-vektor
x = [handles.MyData.Layers(layerPos).Images.EchoTime]';
y = [handles.MyData.Layers(layerPos).ROIS(1).ROI.MeanValue]';

waitbar(1/3, wb);
% Fit x og y-værdierne
f = fit(x, y, 'exp1');
waitbar(2/3, wb);
handles.MyData.Layers(layerPos).ROIS(1).ROI.T2 = -1/f.b;

axes(handles.axT2Graph)
waitbar(3/3)
plot(f, x, y);

close(wb);
end

