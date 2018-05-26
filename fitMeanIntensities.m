function handles = fitMeanIntensities(handles, ROIidx)
%FITMEANINTENSITIES Fitter middelintensiteterne og udregner T2* derfra
%   Detailed explanation goes here

wb = waitbar(0, 'Beregner T2*');
% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');

% Lav x-vektor
x = [handles.MyData.Layers(layerPos).Images.EchoTime]';
y = [handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.MeanValue]';

waitbar(1/3, wb);
set(handles.figure1,'Pointer','watch');
% Fit x og y-værdierne
f = fit(x, y, 'exp1');
waitbar(2/3, wb);
T2 = -1/f.b;
set(handles.txtT2, 'String', round(T2,2));
handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.FitData = f;
handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.T2 = T2;

axes(handles.axT2Graph)
waitbar(3/3)
plot(f, x, y);

close(wb);
set(handles.figure1,'Pointer','arrow');
end

