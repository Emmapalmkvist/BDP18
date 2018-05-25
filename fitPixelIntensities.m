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
