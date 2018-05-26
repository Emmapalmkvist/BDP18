function handles = fitPixelIntensities(handles, ROIID)
%FITPIXELINTENSITIES Fitter hver enkel pixel gennem ekkotiderne og udregner T2*-v�rdien for pixelen
%   Detailed explanation goes here

wb = waitbar(0, 'Beregner pixelvis T2*');
set(handles.figure1,'Pointer','watch')

% Find antallet af pixels i ROI'en (i det snit)
layerPos = get(handles.SliderLayer, 'Value');
numbPix = length(handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Pixels);

% Antallet af billeder i snittet (antal ekkotider)
echoTimes = get(handles.SliderROIPicture, 'Max');

% Pr�allok�r til at indeholde T2-v�rdierne for hver enkel pixel
PixelT2 = zeros(1, numbPix);

for i = 1:numbPix
    % Pr�allok�r til at indeholde pixelv�rdi pr. echotid
    Pix = zeros(1, echoTimes);
    
   parfor ii = 1:echoTimes
       Pix(ii) = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(ii).Pixels(i);
   end
   % Vend vektorerne
   Pix = Pix';
   Echo = ([handles.MyData.Layers(layerPos).Images.EchoTime])';
   % Fit og f� goodness of fit
   [f, gof] = fit(Echo, Pix, 'exp1');
   
  handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(i) = gof;
   % Udregn T2*
   PixelT2(i) = -1/f.b;
   
   waitbar(i/numbPix,wb);
end

handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2 = PixelT2(:);

maxRMSE = max([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxRMSE = maxRMSE;
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinRMSE = min([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]);

% Vis maks-v�rdi ude i GUI samt deaktiv�r plus-knap
set(handles.etExcludePixels, 'String', num2str(round(maxRMSE, 2)));
set(handles.btnExcludePlus, 'enable', 'off');

handles = colormapPixels(handles, ROIID, layerPos, handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes);

% Luk waitbaren
close(wb)
set(handles.figure1,'Pointer','arrow')
end

