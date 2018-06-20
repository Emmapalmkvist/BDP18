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
%       - getMeanROI
%       - fitMeanIntensities

layerPos = get(handles.SliderLayer, 'Value');

% Tjek hvilken type værdi der er valgt at sortere efter: RMSE eller R^2
% strcmp: sammenligner indholdet i inputparamenteret type en af tekstene
% fra radiobuttons
if(strcmp(type, 'rbRMSE'))
    % Find placering af de værdier, som er større end eller lig den
    % specificerede værdi
    % FINDER PIXELS SOM SKAL FJERNES
    valueLoc = ...
     [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]...
     >= boundary;
elseif(strcmp(type, 'rbR2'))
    % Find placering af de værdier, som er mindre end eller lig den
    % specificerede værdi
    % FINDER PIXELS SOM SKAL FJERNES
    valueLoc = ...
     [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]...
     <= boundary;
end

% Find værdiernes tilhørende index i billedet
% idx: placering af pixels i ROI'en
idx = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes;
% Fjern de indexes, som tilhører pixels, der skal eksluderes
idx(valueLoc) = [];

% Kør colormapning - nu med et reduceret antal af pixels (ud fra idx)
handles = colormapPixels(handles, ROIID, layerPos, idx);

% Lav en maske
% Finder størrelse på billederne
sz = size(handles.MyData.Layers(layerPos).Images(1).Image);
% størrelsen bruges til at klargøre en maske på samme størrelse som
% billedet
mask = zeros(sz);
% I masken lægges ettaller der, hvor der er gyldige pixels
mask(idx) = 1;

% Få gennemsnitsværdier for tilbageværende pixels
% Bruger den lavede maske som inputargument
[y, ~] = getMeanROI(handles, mask);

% Udregn gennemsnitlige T2*-værdi for resterende pixels
% y er middelværdierne og gives med som 3. argument (modsat tidligere, hvor
% der kun gives 2 argumenter som input)
handles = fitMeanIntensities(handles, ROIID, y);
end

