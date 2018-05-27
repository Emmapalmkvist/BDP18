function handles = colormapPixels(handles, ROIID, layerPos, indexes)
%COLORMAPPIXELS Farvelægger pixel'ene i en ROI ud fra T2*-værdierne


% Lav et billede til T2-værdierne
im = zeros(256, 256);



for i = 1:length(indexes)
    loc = find([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes] == indexes(i));
    im(indexes(i)) = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2(loc);
end

% Normaliser T2-værdierne til at ligge mellem 0-1
%imNorm = (im-min(im(:)))/(max(im(:))-min(im(:)));

% Hent masken
%mask = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.Mask;
mask = logical(im);

% Fjern indhold udenfor ROI'en
%imNorm(mask == 0) = 0;

% Find det nuværende billede
ImPos = ceil(get(handles.SliderLayer, 'Value'));
ImPosROI = round(get(handles.SliderROIPicture, 'Value'));
currentIm = double(handles.MyData.Layers(ImPos).Images(ImPosROI).Image);

% Konverter billedet (bestående af pixelsværdier) til indexeret billede med
% den grå colormap med N = 128
%currentIm = gray2ind(double(currentIm)/max(currentIm(:)),128);

% Normaliserer billedet
currentIm = currentIm/max(currentIm(:));

% Clear aksen
cla(handles.axDrawROI)
% Vælg akse
axes(handles.axDrawROI)

% Klargør til at lægge billeder ovenpå hinanden og få et handle dertil
h = subimage(currentIm);

% Sæt aksen til at vise det, som ligger inden i mask
set(h, 'AlphaData', mask);
% Vis indholdet inden i ROIen og farvelæg det med jet-colormappen (som er
% flippet: rød = 1, blå = 0)
%imagesc(imNorm); colormap(flipud(jet));
imagesc(im); colormap(flipud(jet));
% Få den nuværende akseskalering
axScale = caxis;
hold on;
% Læg billedet på igen og få et handle dertil
h = subimage(currentIm);
% Sæt akseskaleringen til at være den samme
caxis(axScale)
% Gem handle til billedet
handles.MyData.HandleToCurrentROIImage = h;

% Sæt aksen til at vise det, som ligger uden for masken
set(h, 'AlphaData', ~mask);

displayROISonPicture(handles);

end

% Placering af farvelagt ROI-område over MRI billede lavet med inspiration fra: https://stackoverflow.com/questions/16815192/how-to-overlay-a-rgb-roi-on-top-of-a-greyscale-image-in-a-guide-axes
