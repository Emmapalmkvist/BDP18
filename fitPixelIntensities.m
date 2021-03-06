function handles = fitPixelIntensities(handles, ROIID)
%FITPIXELINTENSITIES Fitter hver enkel pixel gennem gennem ekkotiderne og
%udregner T2*-v�rdien for pixelen
%   Indl�ser hver enkel pixels signalintensitet for hver ekkotid og
%   beregner et eksponentiel fit herfor. b-konstanten fra fittet bruges til
%   at udregne T2*. T2* og Goodness of Fit gemmes i handles.
%   Farvel�gning af pixels ud fra T2*-v�rdierne udf�res ved kald af
%   funktionen hertil til sidst i denne funktion.
%
%   INPUT:
%   handles: handle til elementer i gui
%   ROIID: et id (placering i handles) p� den ROI, der skal udregnes for
%
%   OUTPUT:
%   handles med de nye v�rdier i MyData.Layers.ROIS.ROI.EchoPix:
%       - GOF: Goodness of Fit-v�rdierne for hver pixel
%       - T2: T2*-v�rdien for hver pixel
%       - MaxRMSE: Den st�rste RMSE-v�rdi for pixelene i ROI'en
%       - MinRMSE: Den laveste RMSE-v�rdi for pixelene i ROI'en
%       - MaxR2: Den st�rste R^2-v�rdi for pixelene i ROI'en
%       - MinR2: Den laveste R^2-v�rdi for pixelene i ROI'en

wb = waitbar(0, 'Beregner pixelvis T2*');
%Mus til ur 
set(handles.figure1,'Pointer','watch')

% Find antallet af pixels i ROI'en (i det snit)
% Vi tager den bare fra den f�rste eccotid (eccopix), fordi der ligger lige
% mange pixels i hver eccotid
layerPos = get(handles.SliderLayer, 'Value');
numbPix = ...
    length(handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Pixels);

% Antallet af billeder i snittet (antal ekkotider)
echoTimes = get(handles.SliderROIPicture, 'Max');

% Pr�allok�r til at indeholde T2-v�rdierne for hver enkel pixel
%man kunne ogs� have brugt NaN, da vi s� kunne se hvor den var g�et galt
PixelT2 = zeros(1, numbPix);


%for-loop for hver enkelt pixel
for i = 1:numbPix
    % Pr�allok�r til at indeholde pixelv�rdi pr. echotid
    Pix = zeros(1, echoTimes);
    
    %Paralleliser for - loopen - eccotider i hver pixel
   parfor ii = 1:echoTimes
       Pix(ii) = ...
           handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(ii).Pixels(i);
   end
   
   % Vend vektorerne til fit-metoden og fit (f� b�de fit og goodness of
   % fit)
   Pix = Pix';
   Echo = ([handles.MyData.Layers(layerPos).Images.EchoTime])';
   [f, gof] = fit(Echo, Pix, 'exp1');
   handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(i) = gof;
   
   % Udregn T2* for hver pixel ud fra dens fit-koefficient b 
   PixelT2(i) = -1/f.b;
   
   if isvalid(wb)
       waitbar(i/numbPix,wb);
   end
   
end

handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).T2 = PixelT2(:);

% Find minimum v�rdien for R^2.
minR2 = ...
  min([handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).GOF(:).rsquare]);
% det der bliver udskrevet, 3 for 3 decimaler
minR2 = num2str(round(minR2, 3));
% Lav vektor af v�rdier, som vil medf�re, at der rundes op
highValues = ['5'; '6'; '7'; '8'; '9'];
% Se, om den sidste v�rdi er lig et af ovenst�ende tal
% hvis den er sand returernes 1 og falsk returneres 0.
isHighValue = (minR2(end) == highValues(:));
% Nedenst�ende if er for at der bliver rundet ned til 2 decimaler for
% min-v�rdien af R^2 
%Grunden til at vi gerne vil runde ned og ikke op, er at vi ikke vil
%risikere at der allerede er valgt nogle plixels fra uden af brugen kan se
%det. 
if (~isempty(isHighValue(isHighValue)))
    
    minR2(end) = '4';
    minR2 = str2double(minR2);
else
    minR2 = str2double(minR2);
end
    
% Vis min-v�rdi ude i GUI (default er valgt som R^2) samt aktiv�r
% plus-knap og deaktiv�r minus-knap
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

% Farvel�g
handles = colormapPixels(handles, ROIID, layerPos,...
    handles.MyData.Layers(layerPos).ROIS(ROIID).ROI.EchoPix(1).Indexes);
% Det sidste inputargument til colomapPixels er "indexes". Disse er
% index-v�rdierne (placeringerne) for pixelene i ROI'en

% Luk waitbaren (hvis den stadig er �ben)
if isvalid(wb)
    close(wb);
end

set(handles.figure1,'Pointer','arrow')
end

