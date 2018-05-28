function handles = excludePixels(handles, ROIID, type, boundary)
%EXCLUDEPIXELS Eksluderer d�rligt fittede pixels ud fra den specificerede
%v�rdi
%   Frasorterer de pixels, som har et Goodness of Fit, som ligger uden for
%   den specificerede v�rdi (boundary). Derefter farvel�gges der p� ny og
%   en ny, revideret T2*-v�rdi beregnes.
%
%   INPUT:
%   handles: handle til elementer i gui
%   ROIID: et id (placering i handles) p� den ROI, der ekskluderes pixels
%   fra
%   type: hvilken Goodness of Fit-type der er valgt at ekskludere ud fra
%   (RMSE eller R^2)
%   boundary: den specificerede v�rdi, som der skal ekskluderes ud fra
%
%   OUTPUT:
%   handles med nye v�rdier returneret fra funktionerne: 
%       - colormapPixels
%       - getMeanRoi
%       - fitMeanIntensities

layerPos = get(handles.SliderLayer, 'Value');

% Tjek hvilken type v�rdi der er valgt at sortere efter: RMSE eller R^2
if(strcmp(type, 'rmse'))
    % Find placering af de v�rdier, som er st�rre end eller lig den
    % specificerede v�rdi
    valueLoc = ...
     [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]...
     >= boundary;
elseif(strcmp(type, 'R^2'))
    % Find placering af de v�rdier, som er st�rre end eller lig den
    % specificerede v�rdi
    valueLoc = ...
     [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]...
     <= boundary;
end

% Find v�rdiernes tilh�rende index i billedet
idx = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes;
% Fjern disse indexes
idx(valueLoc) = [];

% K�r colormapning
handles = colormapPixels(handles, ROIID, layerPos, idx);

% Lav en maske
sz = size(handles.MyData.Layers(layerPos).Images(1).Image);
mask = zeros(sz);
mask(idx) = 1;

% F� gennemsnitsv�rdier for tilbagev�rende pixels
[y, ~] = getMeanROI(handles, mask);

% Udregn gennemsnitlige T2*-v�rdi for resterende pixels
handles = fitMeanIntensities(handles, ROIID, y);
end

