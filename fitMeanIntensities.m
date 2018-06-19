function handles = fitMeanIntensities(handles, ROIidx, meanValues)
%FITMEANINTENSITIES plotter middelintensiteterne og ekkotiderne og udregner T2* derfra
%   Laver en x- og y-vektor til fit-funktionen. Afh�ngigt af antallet af
%   inputargumenter, hentes middelv�rdi fra handles eller det 3.
%   inputargument.
%   Bruger x og y til at udf�re eksponentielt fit og evt. plotte fittet.
%   Outputtet fra fittet anvendes til at beregne T2*
%
%   INPUT:
%   handles: handle til elementer i gui
%   ROIidx: et id (placering i handles) p� den ROI, der skal udregnes for
%   meanValues: er 3. inputargument, hvis funktionen kaldes ved eksludering
%   af pixels. Er middelv�rdierne for de pixels, der skal fittes for
%
%   OUTPUT:
%   handles med de nye v�rdier i MyData.Layers.ROIS.ROI:
%   2 inputargumenter
%       - FitData: oplysninger om fittet. Anvendes til at plotte p� ny
%       - T2: den udregnede T2*-v�rdi
%   3 inputargumenter:
%       - RevideretT2: den udregnede, revidere T2*-v�rdi ud fra de restende
%       pixels

wb = waitbar(0, 'Beregner T2*');
% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');

% Lav x-vektor, ud fra ekkotider
x = [handles.MyData.Layers(layerPos).Images.EchoTime]';

%Lav y-vektor, du fra middelv�rdier
% Hvis der er to input vil det v�re handles og ROIidx. MeanValue for hele
% ROI er gemt i handles
if nargin == 2 
    y = [handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.MeanValue]';
%Det trejde input er meanValues fra excludePixels dvs. middelv�rdien af de
%tilbagev�rende pixels. 
%Den vil v�re der n�r man har v�ret inde og frav�lge pixels. 
elseif nargin == 3
    y = meanValues';
end

if isvalid(wb)
    waitbar(1/3, wb);
end

%Mus bliver til ur
set(handles.figure1,'Pointer','watch');

% Fit x og y-v�rdierne
f = fit(x, y, 'exp1');

if isvalid(wb)
    waitbar(2/3, wb);
end

%kommer fra omskrivning af opgivet formel
T2 = -1/f.b;

if nargin == 2
    set(handles.txtT2, 'String', round(T2, 2));
    handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.FitData = f;
    handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.T2 = T2;

    axes(handles.axT2Graph)
    
    if isvalid(wb)
        waitbar(3/3, wb)
    end
    
    plot(f, x, y);
    set(get(handles.axT2Graph, 'ylabel'), 'string', 'Middelintensitet'); 
    set(get(handles.axT2Graph, 'xlabel'), 'string', 'Ekkotid [ms]');
    
elseif nargin == 3
    if isvalid(wb)
        waitbar(3/3, wb);
    end
    
    set(handles.txtT2Revideret, 'String', round(T2, 2));
    handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.RevideretT2 = T2;
    
    % Dvs. hvis man ikke f�r vist den fittet kurve ved revideret T2-v�rdi
end

close(wb);
%Mus tilbage til pil 
set(handles.figure1,'Pointer','arrow');
end

