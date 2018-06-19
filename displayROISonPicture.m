function displayROISonPicture(handles)
%DISPLAYROISONPICTURE Summary of this function goes here
%   Denne funktion sørger for, at når der tegnet en ROI på et af billederne i
%   et snit, så følger ROIen med når der skiftes billede (ekkotid) på slideren.
%
%   INPUT:
%   handles: handle til elementer i gui
%
%   OUTPUT:
%   Funktionen har ingen output argumenter, da den ikke ændrer på data
%   eller generer ny data

% Find snit
layerPos = get(handles.SliderLayer, 'Value');

axes(handles.axDrawROI);

% Gå hver ROI igennem og tegn den på aksen
for ii = 1:length(handles.MyData.Layers(layerPos).ROIS(:))
    if isfield(handles.MyData.Layers(layerPos).ROIS(ii).ROI,'Location')
        %gca = get current axes 
        %imploy tegner ROI ud fra lokationeren 
        impoly(gca,handles.MyData.Layers(layerPos).ROIS(ii).ROI.Location);
        pos = handles.MyData.Layers(layerPos).ROIS(ii).ROI.Location;
        id = handles.MyData.Layers(layerPos).ROIS(ii).ROI.ROIID;
        %Placering af teksten - text tager x, y og string. Vi tager mean på
        %x og y for at få teksten tæt på punktet. 
        %Clipping, prøvet at få testen til at blive inde i aksen, i
        %tilfælde at at ROI står meget tæt på kanten. 
        text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on');
    else
        return;
    end
end
end

