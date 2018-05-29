function handles = colormapPixels(handles, ROIID, layerPos, indexes)
%COLORMAPPIXELS Farvelægger pixel'ene i en ROI ud fra T2*-værdierne
%   Finder placering af de pixels som skal farvelægges og placerer den
%   tilhørende T2*-værdi på placeringen. Farvelægger således, at det
%   originale billede vises med et farvet område der hvor ROI'en er tegnet
%
%   INPUT:
%   handles: handle til elementer i gui
%   ROIID: et id (placering i handles) på den ROI, der skal farves for
%
%   OUTPUT:
%   handles med ny(e) værdi(er) i MyData:
%       - HandleToCurrentROIImage: et handle til det nuværende billede,
%       således at det kan bruges, når der skal tegnes flere ROIs

% Lav et billede til T2-værdierne
sz = size(handles.MyData.Layers(layerPos).Images(1).Image);
im = zeros(sz);

% Indlæs T2-værdi på hver pixel-plads
for i = 1:length(indexes)
 loc = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes]...
     == indexes(i));
 im(indexes(i)) = ...
     handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2(loc);
end

% Lav en maske for pixelene
mask = logical(im);

% Find det nuværende billede, så dette kan bruges til farvelægning
ImPos = ceil(get(handles.SliderLayer, 'Value'));
ImPosROI = round(get(handles.SliderROIPicture, 'Value'));
currentIm = double(handles.MyData.Layers(ImPos).Images(ImPosROI).Image);
% Normalisér billedet
currentIm = currentIm/max(currentIm(:));

% Clear aksen, som der skal farvelægges på
cla(handles.axDrawROI)
% Vælg aksen
axes(handles.axDrawROI)

% Læg det nuværende billede i "aksen" og gem handle dertil i variabel
h = subimage(currentIm);
% Sæt aksen til at vise det, som ligger inden i mask, ved at anvende at
% AlphaData kan sættes for et handle til et billede
set(h, 'AlphaData', mask);
% Vis indholdet inden i ROIen og farvelæg det med jet-colormappen (som er
% flippet: rød = lav værdi, blå = høj værdi)
imagesc(im); colormap(flipud(jet));
% Få den nuværende akseskalering
axScale = caxis;
hold on;
% Læg billedet på igen og få et handle dertil
h = subimage(currentIm);
% Sæt akseskaleringen til at være den samme som før
caxis(axScale)
% Gem handle til billedet i handles
handles.MyData.HandleToCurrentROIImage = h;

% Sæt aksen til at vise det, som ligger uden for masken
set(h, 'AlphaData', ~mask);

% Fjern aksebenævnelser
set(handles.axDrawROI, 'XTick', []);
set(handles.axDrawROI, 'YTick', [])

displayROISonPicture(handles);

end

% Placering af farvelagt ROI-område over MR-billede er lavet med inspiration 
% fra: https://stackoverflow.com/questions/16815192/how-to-overlay-a-rgb-roi-on-top-of-a-greyscale-image-in-a-guide-axes
