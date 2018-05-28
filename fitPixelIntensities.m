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
   
   if isvalid(wb)
       waitbar(i/numbPix,wb);
   end
   
end

handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2 = PixelT2(:);

% Find minimum værdien for R^2 og sæt den i brugergrænsefladen
minR2 = min([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]);
minR2 = num2str(round(minR2, 3));
% Lav vektor af værdier, som vil medføre, at der rundes op
roundUp = ['5'; '6'; '7'; '8'; '9'];
% Se, om den sidste værdi er lig et af ovenstående tal
logic = (minR2(end) == roundUp(:));
if (~isempty(logic(logic)))
    % Denne if er før at der bliver rundet ned, i stedet for op på
    % min-værdien af R^2
    minR2(end) = '4';
    minR2 = str2double(minR2);
else
    minR2 = str2double(minR2);
end
    
% Vis min-værdi ude i GUI (default er valgt som R^2) samt aktiver plus-knap og deaktivér minus-knap
set(handles.etExcludePixels, 'String', num2str(round(minR2, 2)));
%set(handles.btnExcludePlus, 'enable', 'on');
%set(handles.btnExcludeMinus, 'enable', 'off');

% Gem min og max for RMSE og R^2
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxRMSE = max([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxR2 = max([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinRMSE = min([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinR2 = minR2;

% Farvelæg
handles = colormapPixels(handles, ROIID, layerPos, handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes);

% Luk waitbaren (hvis den stadig er åben)
if isvalid(wb)
    close(wb);
end

set(handles.figure1,'Pointer','arrow')
end

