function handles = fitPixelIntensities(handles)
%FITPIXELINTENSITIES Fitter hver enkel pixel gennem ekkotiderne og udregner T2*-værdien for pixelen
%   Detailed explanation goes here

wb = waitbar(0, 'Beregner pixelvis T2*');

% Find antallet af pixels i ROI'en
layerPos = get(handles.SliderLayer, 'Value');
numbPix = length(handles.MyData.Layers(layerPos).ROIS(1).ROI.EchoPix(1).Pixels);

% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');

% Antallet af billeder i snittet (antal ekkotider)
echoTimes = get(handles.SliderROIPicture, 'Max');

% Præallokér til at indeholde T2-værdierne for hver enkel pixel
PixelT2 = zeros(1, numbPix);
GOF = struct([]);

for i = 1:numbPix
    % Præallokér til at indeholde pixelværdi pr. echotid
    Pix = zeros(1, echoTimes);
    % Præallokér til at indeholde ekkotiden
    %Echo =  zeros(1, echoTimes);
   parfor ii = 1:echoTimes
       Pix(ii) = handles.MyData.Layers(layerPos).ROIS(1).ROI.EchoPix(ii).Pixels(i);
       %Echo(ii) = handles.MyData.Layers(layerPos).Images(ii).EchoTime;
   end
   % Vend vektorerne
   Pix = Pix';
   Echo = ([handles.MyData.Layers(layerPos).Images.EchoTime])';
   % Fit og få goodness of fit
   [f, gof] = fit(Pix, Echo, 'exp1');
   %GOF = gof;
  handles.MyData.Layers(layerPos).ROIS(1).ROI.EchoPix(1).GOF(i) = gof;
   % Udregn T2*
   PixelT2(i) = -1/f.b;
   waitbar(i/numbPix,wb);
end

 %handles.MyData.Layers(layerPos).ROIS(1).ROI.EchoPix.GOF = GOF;

handles.MyData.Layers(layerPos).ROIS(1).ROI.EchoPix(1).T2 = PixelT2(:);


end

