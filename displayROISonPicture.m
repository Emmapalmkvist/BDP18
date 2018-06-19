function displayROISonPicture(handles)
%DISPLAYROISONPICTURE Summary of this function goes here
%   Denne funktion s�rger for, at n�r der tegnet en ROI p� et af billederne i
%   et snit, s� f�lger ROIen med n�r der skiftes billede (ekkotid) p� slideren.
%
%   INPUT:
%   handles: handle til elementer i gui
%
%   OUTPUT:
%   Funktionen har ingen output argumenter, da den ikke �ndrer p� data
%   eller generer ny data

% Find snit
layerPos = get(handles.SliderLayer, 'Value');

axes(handles.axDrawROI);

% G� hver ROI igennem og tegn den p� aksen
for ii = 1:length(handles.MyData.Layers(layerPos).ROIS(:))
    if isfield(handles.MyData.Layers(layerPos).ROIS(ii).ROI,'Location')
        %gca = get current axes 
        %imploy tegner ROI ud fra lokationeren 
        impoly(gca,handles.MyData.Layers(layerPos).ROIS(ii).ROI.Location);
        pos = handles.MyData.Layers(layerPos).ROIS(ii).ROI.Location;
        id = handles.MyData.Layers(layerPos).ROIS(ii).ROI.ROIID;
        %Placering af teksten - text tager x, y og string. Vi tager mean p�
        %x og y for at f� teksten t�t p� punktet. 
        %Clipping, pr�vet at f� testen til at blive inde i aksen, i
        %tilf�lde at at ROI st�r meget t�t p� kanten. 
        text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on');
    else
        return;
    end
end
end

