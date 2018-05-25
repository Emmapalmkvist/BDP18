function handles = fitPixelIntensities(handles)
%FITPIXELINTENSITIES Fitter hver enkel pixel gennem ekkotiderne og udregner T2*-v�rdien for pixelen
%   Detailed explanation goes here

% Find antallet af pixels i ROI'en
layerPos = get(handles.SliderROIPicture, 'Max');
numbPix = handles.MyData.Layers(ImPos).ROIS.ROI(1).EchoPix;

% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');

% Antallet af billeder i snittet (antal ekkotider)
echoTimes = get(handles.SliderROIPicture, 'Max');

% Pr�allok�r til at indeholde T2-v�rdierne for hver enkel pixel
PixelT2 = zeros(1, numbPix);

for i = 1:numbPix
    % Pr�allok�r til at indeholde pixelv�rdi pr. echotid
    Pix = zeros(1, echoTimes);
    % Pr�allok�r til at indeholde ekkotiden
    Echo =  zeros(1, echoTimes);
   parfor ii = 1:echoTimes
       Pix(ii) = handles.MyData.Layers(ImPos).ROIS.ROI(1).EchoPix(ii).Pixels(i);
       Echo(ii) = handles.MyData.Layers(layerPos).Images(iii).EchoTime;
   end
   % Vend vektorerne
   Pix = Pix';
   Echo = Echo';
   % Fit og f� goodness of fit
   [f, gof] = fit(Pix, Echo, 'exp1');
   handles.MyData.Layers(ImPos).ROIS.ROI(1).EchoPix.GOF = gof;
   % Udregn T2*
   PixelT2(i) = -1/f.b
end

handles.MyData.Layers(ImPos).ROIS.ROI(1).EchoPix.T2  =PixelT2;


end

