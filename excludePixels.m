function handles = excludePixels(handles, ROIID, type, boundary)
%EXCLUDEPIXELS Eksluderer dårligt fittede pixels ud fra den specificerede
%værdi
%   Frasorterer de pixels, som har et Goodness of Fit, som ligger uden for
%   den specificerede værdi (boundary). Derefter farvelægges der på ny og
%   en ny, revideret T2*-værdi beregnes.
%
%   INPUT:
%   handles: handle til elementer i gui
%   ROIID: et id (placering i handles) på den ROI, der ekskluderes pixels
%   fra
%   type: hvilken Goodness of Fit-type der er valgt at ekskludere ud fra
%   (RMSE eller R^2)
%   boundary: den specificerede værdi, som der skal ekskluderes ud fra
%
%   OUTPUT:
%   handles med nye værdier returneret fra funktionerne: 
%       - colormapPixels
%       - getMeanRoi
%       - fitMeanIntensities

layerPos = get(handles.SliderLayer, 'Value');

% Tjek hvilken type værdi der er valgt at sortere efter: RMSE eller R^2
if(strcmp(type, 'rmse'))
    % Find placering af de værdier, som er større end eller lig den
    % specificerede værdi
    valueLoc = ...
     [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]...
     >= boundary;
elseif(strcmp(type, 'R^2'))
    % Find placering af de værdier, som er større end eller lig den
    % specificerede værdi
    valueLoc = ...
     [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]...
     <= boundary;
end

% Find værdiernes tilhørende index i billedet
idx = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes;
% Fjern disse indexes
idx(valueLoc) = [];

% Kør colormapning
handles = colormapPixels(handles, ROIID, layerPos, idx);

% Lav en maske
sz = size(handles.MyData.Layers(layerPos).Images(1).Image);
mask = zeros(sz);
mask(idx) = 1;

% Få gennemsnitsværdier for tilbageværende pixels
[y, ~] = getMeanROI(handles, mask);

% Udregn gennemsnitlige T2*-værdi for resterende pixels
handles = fitMeanIntensities(handles, ROIID, y);
end

