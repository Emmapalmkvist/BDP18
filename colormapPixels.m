function handles = colormapPixels(handles, ROIID, layerPos, indexes)
%COLORMAPPIXELS Farvel�gger pixel'ene i en ROI ud fra T2*-v�rdierne

% Lav et billede til T2-v�rdierne
im = zeros(256, 256);

for i = 1:length(indexes)
    loc = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes] == indexes(i));
    im(indexes(i)) = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2(loc);
end

% Lav en maske for de resterende pixels
mask = logical(im);

% Find det nuv�rende billede
ImPos = ceil(get(handles.SliderLayer, 'Value'));
ImPosROI = round(get(handles.SliderROIPicture, 'Value'));
currentIm = double(handles.MyData.Layers(ImPos).Images(ImPosROI).Image);

% Normaliserer billedet
currentIm = currentIm/max(currentIm(:));

% Clear aksen
cla(handles.axDrawROI)
% V�lg akse
axes(handles.axDrawROI)

% Klarg�r til at l�gge billeder ovenp� hinanden og f� et handle dertil
h = subimage(currentIm);

% S�t aksen til at vise det, som ligger inden i mask
set(h, 'AlphaData', mask);
% Vis indholdet inden i ROIen og farvel�g det med jet-colormappen (som er
% flippet: r�d = 1, bl� = 0)
%imagesc(imNorm); colormap(flipud(jet));
imagesc(im); colormap(flipud(jet));
% F� den nuv�rende akseskalering
axScale = caxis;
hold on;
% L�g billedet p� igen og f� et handle dertil
h = subimage(currentIm);
% S�t akseskaleringen til at v�re den samme
caxis(axScale)
% Gem handle til billedet
handles.MyData.HandleToCurrentROIImage = h;

% S�t aksen til at vise det, som ligger uden for masken
set(h, 'AlphaData', ~mask);

% Fjern akseben�vnelser
set(handles.axDrawROI, 'XTick', []);
set(handles.axDrawROI, 'YTick', [])

displayROISonPicture(handles);

end

% Placering af farvelagt ROI-omr�de over MRI billede lavet med inspiration fra: https://stackoverflow.com/questions/16815192/how-to-overlay-a-rgb-roi-on-top-of-a-greyscale-image-in-a-guide-axes
