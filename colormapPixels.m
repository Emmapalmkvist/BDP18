function handles = colormapPixels(handles, ROIID, layerPos)
%COLORMAPPIXELS Farvel�gger pixel'ene i en ROI ud fra T2*-v�rdierne
%   Detailed explanation goes here

% Lav et billede til T2-v�rdierne
im = double(handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.Mask);
pic = double(handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.Mask);

idx = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes;

for i = 1:length(idx)
    im(idx(i)) = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2(i);
    pic(idx(i)) = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(i).rsquare;
end

% Normaliser T2-v�rdierne til at ligge mellem 0-1
imNorm = (im-min(im(:)))/(max(im(:))-min(im(:)));

% Find det nuv�rende billede
ImPos = ceil(get(handles.SliderLayer, 'Value'));
ImPosROI = round(get(handles.SliderROIPicture, 'Value'));
currentIm = double(handles.MyData.Layers(ImPos).Images(ImPosROI).Image);

% Hent masken
mask = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.Mask;

% Konverter billedet (best�ende af pixelsv�rdier) til indexeret billede med
% den gr� colormap med N = 128
%currentIm = gray2ind(double(currentIm)/max(currentIm(:)),128);

% Normaliserer billedet
currentIm = currentIm/max(currentIm(:));

% V�lg akse
axes(handles.axDrawROI)
% Klarg�r til at l�gge billeder ovenp� hinanden og f� et handle dertil
h = subimage(currentIm);

% S�t aksen til at vise det, som ligger inden i mask
set(h, 'AlphaData', mask);
% Vis indholdet inden i ROIen og farvel�g det med jet-colormappen (som er
% flippet: r�d = 1, bl� = 0)
imagesc(imNorm); colormap(flipud(jet))
hold on;
% L�g billedet p� igen og f� et handle dertil
h = subimage(currentIm);

% Gem handle til billedet
handles.MyData.HandleToCurrentROIImage = h;

% S�t aksen til at vise det, som ligger uden for masken
set(h, 'AlphaData', ~mask);

ROI = displayROISonPicture(handles);


end

% Placering af farvelagt ROI-omr�de over MRI billede lavet med inspiration fra: https://stackoverflow.com/questions/16815192/how-to-overlay-a-rgb-roi-on-top-of-a-greyscale-image-in-a-guide-axes
