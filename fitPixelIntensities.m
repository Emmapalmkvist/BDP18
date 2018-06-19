function handles = fitPixelIntensities(handles, ROIID)
%FITPIXELINTENSITIES Fitter hver enkel pixel gennem gennem ekkotiderne og
%udregner T2*-værdien for pixelen
%   Indlæser hver enkel pixels signalintensitet for hver ekkotid og
%   beregner et eksponentiel fit herfor. b-konstanten fra fittet bruges til
%   at udregne T2*. T2* og Goodness of Fit gemmes i handles.
%   Farvelægning af pixels ud fra T2*-værdierne udføres ved kald af
%   funktionen hertil til sidst i denne funktion.
%
%   INPUT:
%   handles: handle til elementer i gui
%   ROIID: et id (placering i handles) på den ROI, der skal udregnes for
%
%   OUTPUT:
%   handles med de nye værdier i MyData.Layers.ROIS.ROI.EchoPix:
%       - GOF: Goodness of Fit-værdierne for hver pixel
%       - T2: T2*-værdien for hver pixel
%       - MaxRMSE: Den største RMSE-værdi for pixelene i ROI'en
%       - MinRMSE: Den laveste RMSE-værdi for pixelene i ROI'en
%       - MaxR2: Den største R^2-værdi for pixelene i ROI'en
%       - MinR2: Den laveste R^2-værdi for pixelene i ROI'en

wb = waitbar(0, 'Beregner pixelvis T2*');
set(handles.figure1,'Pointer','watch')

% Find antallet af pixels i ROI'en (i det snit)
layerPos = get(handles.SliderLayer, 'Value');
numbPix = ...
    length(handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Pixels);

% Antallet af billeder i snittet (antal ekkotider)
echoTimes = get(handles.SliderROIPicture, 'Max');

% Præallokér til at indeholde T2-værdierne for hver enkel pixel
PixelT2 = zeros(1, numbPix);

for i = 1:numbPix
    % Præallokér til at indeholde pixelværdi pr. echotid
    Pix = zeros(1, echoTimes);
    
   parfor ii = 1:echoTimes
       Pix(ii) = ...
           handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(ii).Pixels(i);
   end
   % Vend vektorerne til fit-metoden og fit (få både fit og goodness of
   % fit)
   Pix = Pix';
   Echo = ([handles.MyData.Layers(layerPos).Images.EchoTime])';
   [f, gof] = fit(Echo, Pix, 'exp1');
   handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(i) = gof;
   
   % Udregn T2*
   PixelT2(i) = -1/f.b;
   
   if isvalid(wb)
       waitbar(i/numbPix,wb);
   end
   
end

handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2 = PixelT2(:);

% Find minimum værdien for R^2
minR2 = ...
  min([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]);
minR2 = num2str(round(minR2, 3));
% Lav vektor af værdier, som vil medføre, at der rundes op
highValues = ['5'; '6'; '7'; '8'; '9'];
% Se, om den sidste værdi er lig et af ovenstående tal
isHighValue = (minR2(end) == highValues(:));
% Nedenstående if er for at der bliver rundet ned til 2 decimaler for
% min-værdien af R^2 
if (~isempty(isHighValue(isHighValue)))
    
    minR2(end) = '4';
    minR2 = str2double(minR2);
else
    minR2 = str2double(minR2);
end
    
% Vis min-værdi ude i GUI (default er valgt som R^2) samt aktivér
% plus-knap og deaktivér minus-knap
set(handles.btnGrpExclude, 'SelectedObject', handles.rbR2);
set(handles.etExcludePixels, 'String', num2str(round(minR2, 2)));
set(handles.btnExcludePlus, 'enable', 'on');
set(handles.btnExcludeMinus, 'enable', 'off');

% Gem min og max for RMSE og R^2
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxRMSE = ...
  max([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MaxR2 = ...
  max([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinRMSE = ...
  min([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rmse]);
handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).MinR2 = minR2;

% Farvelæg
handles = colormapPixels(handles, ROIID, layerPos,...
    handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes);

% Luk waitbaren (hvis den stadig er åben)
if isvalid(wb)
    close(wb);
end

set(handles.figure1,'Pointer','arrow')
end

