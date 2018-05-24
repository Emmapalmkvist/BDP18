function handles = CreateROIs(handles)
axes(handles.axDrawROI);            % Udvælgelse af axes der kan tegnes på.

% Tjekker om handles indeholde MyData eller om MyData er tom og 
% notificerer med messagebox og returnerer fra
% funktionen, hvis det er tilfældet.
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Indlæs venligst billede');
    return;
end    

layer = get(handles.SliderLayer, 'Value');

%if 	nargin == 1
ROIS = impoly();
handles.MyData.Layers(layer).ROIS = ROIS;               % Ny ROI
handles.MyData.Layers.ROIS.Deletable = 0; % Funktionen Deletable slåes fra.
handles.MyData.Layers(layer).ROIS.pos = getPosition(handles.MyData.Layer(layer).ROIS);                     % Henter positionen (x,y,w,h) på den valgte ROI.

end

