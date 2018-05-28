function handles = fitPixelIntensities(handles, ROIID)
%FITPIXELINTENSITIES Fitter hver enkel pixel gennem ekkotiderne og udregner T2*-værdien for pixelen
%   Detailed explanation goes here

wb = waitbar(0, 'Beregner pixelvis T2*');
set(handles.figure1,'Pointer','watch')

% Find antallet af pixels i ROI'en (i det snit)
layerPos = get(handles.SliderLayer, 'Value');
numbPix = length(handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Pixels);

% Antallet af billeder i snittet (antal ekkotider)
echoTimes = get(handles.SliderROIPicture, 'Max');

% Præallokér til at indeholde T2-værdierne for hver enkel pixel
PixelT2 = zeros(1, numbPix);

for i = 1:numbPix
    % Præallokér til at indeholde pixelværdi pr. echotid
    Pix = zeros(1, echoTimes);
    
   parfor ii = 1:echoTimes
       Pix(ii) = handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(ii).Pixels(i);
   end
   % Vend vektorerne
   Pix = Pix';
   Echo = ([handles.MyData.Layers(layerPos).Images.EchoTime])';
   % Fit og få goodness of fit
   [f, gof] = fit(Echo, Pix, 'exp1');
   
  handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(i) = gof;
   % Udregn T2*
   PixelT2(i) = -1/f.b;
   
   if exist('wb','var')
       waitbar(i/numbPix,wb);
   end
   
end

handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2 = PixelT2(:);

maxRMSE = max([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]);
maxR2 = max([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxRMSE = maxRMSE;
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxR2 = maxR2;
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinRMSE = min([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinR2 = min([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]);

% Vis maks-værdi ude i GUI (default er valgt som R^2) samt deaktivér plus-knap
set(handles.etExcludePixels, 'String', num2str(round(maxR2, 2)));
set(handles.btnExcludePlus, 'enable', 'off');

handles = colormapPixels(handles, ROIID, layerPos, handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes);

% Luk waitbaren
if exist('wb','var')
    close(wb);
end

set(handles.figure1,'Pointer','arrow')
end

