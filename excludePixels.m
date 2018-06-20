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
%       - getMeanROI
%       - fitMeanIntensities

layerPos = get(handles.SliderLayer, 'Value');

% Tjek hvilken type v�rdi der er valgt at sortere efter: RMSE eller R^2
% strcmp: sammenligner indholdet i inputparamenteret type en af tekstene
% fra radiobuttons
if(strcmp(type, 'rbRMSE'))
    % Find placering af de v�rdier, som er st�rre end eller lig den
    % specificerede v�rdi
    % FINDER PIXELS SOM SKAL FJERNES
    valueLoc = ...
     [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]...
     >= boundary;
elseif(strcmp(type, 'rbR2'))
    % Find placering af de v�rdier, som er mindre end eller lig den
    % specificerede v�rdi
    % FINDER PIXELS SOM SKAL FJERNES
    valueLoc = ...
     [handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]...
     <= boundary;
end

% Find v�rdiernes tilh�rende index i billedet
% idx: placering af pixels i ROI'en
idx = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes;
% Fjern de indexes, som tilh�rer pixels, der skal eksluderes
idx(valueLoc) = [];

% K�r colormapning - nu med et reduceret antal af pixels (ud fra idx)
handles = colormapPixels(handles, ROIID, layerPos, idx);

% Lav en maske
% Finder st�rrelse p� billederne
sz = size(handles.MyData.Layers(layerPos).Images(1).Image);
% st�rrelsen bruges til at klarg�re en maske p� samme st�rrelse som
% billedet
mask = zeros(sz);
% I masken l�gges ettaller der, hvor der er gyldige pixels
mask(idx) = 1;

% F� gennemsnitsv�rdier for tilbagev�rende pixels
% Bruger den lavede maske som inputargument
[y, ~] = getMeanROI(handles, mask);

% Udregn gennemsnitlige T2*-v�rdi for resterende pixels
% y er middelv�rdierne og gives med som 3. argument (modsat tidligere, hvor
% der kun gives 2 argumenter som input)
handles = fitMeanIntensities(handles, ROIID, y);
end

