function handles = excludePixels(handles, ROIID, type, boundary)
%EXCLUDEPIXELS Eksluderer dårligt fittede pixels ud fra de specificerede
%værdier

layerPos = get(handles.SliderLayer, 'Value');

% Tjek hvilken type værdi der er valgt at sortere efter: RMSE eller R^2
if(strcmp(type, 'rmse'))
    % Find placering af de værdier, som er større end eller lig den specificerede værdi
    valueLoc = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary;
elseif(strcmp(type, 'R^2'))
    % Find placering af de værdier, som er større end eller lig den specificerede værdi
    valueLoc = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare] >= boundary;
end

% Find placering af de værdier, som er større end eller lig den specificerede
% værdi
%rmseLoc = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary);
%valueLoc = [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse] >= boundary;


% Find deres tilhørende index i billede
idx = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes;
% Fjern disse indexes
idx(valueLoc) = [];

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

