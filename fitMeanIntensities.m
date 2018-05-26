function handles = fitMeanIntensities(handles, ROIidx, meanValues)
%FITMEANINTENSITIES Fitter middelintensiteterne og udregner T2* derfra
%   Detailed explanation goes here

wb = waitbar(0, 'Beregner T2*');
% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');

% Lav x-vektor
x = [handles.MyData.Layers(layerPos).Images.EchoTime]';
if nargin == 2
    y = [handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.MeanValue]';
elseif nargin == 3
    y = meanValues';
end

waitbar(1/3, wb);
set(handles.figure1,'Pointer','watch');
% Fit x og y-værdierne
f = fit(x, y, 'exp1');
waitbar(2/3, wb);
T2 = -1/f.b;

if nargin == 2
    set(handles.txtT2, 'String', T2);
    handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.FitData = f;
    handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.T2 = T2;

    axes(handles.axT2Graph)
    waitbar(3/3, wb)
    plot(f, x, y);
elseif nargin == 3
    waitbar(3/3, wb);
    set(handles.txtT2revideret, 'String', round(T2));
    handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.RevideretT2 = T2;
end

close(wb);
set(handles.figure1,'Pointer','arrow');
end

