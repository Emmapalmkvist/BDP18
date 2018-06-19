function handles = fitMeanIntensities(handles, ROIidx, meanValues)
%FITMEANINTENSITIES plotter middelintensiteterne og ekkotiderne og udregner T2* derfra
%   Laver en x- og y-vektor til fit-funktionen. Afhængigt af antallet af
%   inputargumenter, hentes middelværdi fra handles eller det 3.
%   inputargument.
%   Bruger x og y til at udføre eksponentielt fit og evt. plotte fittet.
%   Outputtet fra fittet anvendes til at beregne T2*
%
%   INPUT:
%   handles: handle til elementer i gui
%   ROIidx: et id (placering i handles) på den ROI, der skal udregnes for
%   meanValues: er 3. inputargument, hvis funktionen kaldes ved eksludering
%   af pixels. Er middelværdierne for de pixels, der skal fittes for
%
%   OUTPUT:
%   handles med de nye værdier i MyData.Layers.ROIS.ROI:
%   2 inputargumenter
%       - FitData: oplysninger om fittet. Anvendes til at plotte på ny
%       - T2: den udregnede T2*-værdi
%   3 inputargumenter:
%       - RevideretT2: den udregnede, revidere T2*-værdi ud fra de restende
%       pixels

wb = waitbar(0, 'Beregner T2*');
% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');

% Lav x-vektor
x = [handles.MyData.Layers(layerPos).Images.EchoTime]';
if nargin == 2
    y = [handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.MeanValue]';
elseif nargin == 3
    y = meanValues';
end

if isvalid(wb)
    waitbar(1/3, wb);
end

set(handles.figure1,'Pointer','watch');

% Fit x og y-værdierne
f = fit(x, y, 'exp1');

if isvalid(wb)
    waitbar(2/3, wb);
end

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
end

close(wb);
set(handles.figure1,'Pointer','arrow');
end

