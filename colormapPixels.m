function handles = colormapPixels(handles, ROIID, layerPos, indexes)
%COLORMAPPIXELS Farvel�gger pixel'ene i en ROI ud fra T2*-v�rdierne
%   Finder placering af de pixels som skal farvel�gges og placerer den
%   tilh�rende T2*-v�rdi p� placeringen. Farvel�gger s�ledes, at det
%   originale billede vises med et farvet omr�de der hvor ROI'en er tegnet
%
%   INPUT:
%   handles: handle til elementer i gui
%   ROIID: et id (placering i handles) p� den ROI, der skal farves for
%
%   OUTPUT:
%   handles med ny(e) v�rdi(er) i MyData:
%       - HandleToCurrentROIImage: et handle til det nuv�rende billede,
%       s�ledes at det kan bruges, n�r der skal tegnes flere ROIs

% Lav et billede til T2-v�rdierne
sz = size(handles.MyData.Layers(layerPos).Images(1).Image);
im = zeros(sz);

% Indl�s T2-v�rdi p� hver pixel-plads
for i = 1:length(indexes)
 loc = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes]...
     == indexes(i));
 im(indexes(i)) = ...
     handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2(loc);
end

% Lav en maske for pixelene
mask = logical(im);

% Find det nuv�rende billede, s� dette kan bruges til farvel�gning
ImPos = ceil(get(handles.SliderLayer, 'Value'));
ImPosROI = round(get(handles.SliderROIPicture, 'Value'));
currentIm = double(handles.MyData.Layers(ImPos).Images(ImPosROI).Image);
% Normalis�r billedet
currentIm = currentIm/max(currentIm(:));

% Clear aksen, som der skal farvel�gges p�
cla(handles.axDrawROI)
% V�lg aksen
axes(handles.axDrawROI)

% L�g det nuv�rende billede i "aksen" og gem handle dertil i variabel
h = subimage(currentIm);
% S�t aksen til at vise det, som ligger inden i mask, ved at anvende at
% AlphaData kan s�ttes for et handle til et billede
set(h, 'AlphaData', mask);
% Vis indholdet inden i ROIen og farvel�g det med jet-colormappen (som er
% flippet: r�d = lav v�rdi, bl� = h�j v�rdi)
imagesc(im); colormap(flipud(jet));
% F� den nuv�rende akseskalering
axScale = caxis;
hold on;
% L�g billedet p� igen og f� et handle dertil
h = subimage(currentIm);
% S�t akseskaleringen til at v�re den samme som f�r
caxis(axScale)
% Gem handle til billedet i handles
handles.MyData.HandleToCurrentROIImage = h;

% S�t aksen til at vise det, som ligger uden for masken
set(h, 'AlphaData', ~mask);

% Fjern akseben�vnelser
set(handles.axDrawROI, 'XTick', []);
set(handles.axDrawROI, 'YTick', [])

displayROISonPicture(handles);

end

% Placering af farvelagt ROI-omr�de over MR-billede er lavet med inspiration 
% fra: https://stackoverflow.com/questions/16815192/how-to-overlay-a-rgb-roi-on-top-of-a-greyscale-image-in-a-guide-axes
