function handles = CreateROIs(handles)
axes(handles.axDrawROI);            % Udvælgelse af axes der kan tegnes på.

% Tjekker om handles indeholde ,  eller om MyData er tom og 
% notificerer med messagebox og returnerer fra
% funktionen, hvis det er tilfældet.
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Indlæs venligst billeder');
    return;
end    

ImPos = get(handles.SliderLayer, 'Value');

% Tegn ROI
ROI = impoly;
ROI.Deletable = 0; 
pos = getPosition(ROI);
%mean = getMeanROI(ROI);

% Lav maske ud fra ROI
mask = ROI.createMask;

if isfield(handles.MyData.Layers, 'ROIS')

    if ~isempty(handles.MyData.Layers(ImPos).ROIS)
        idx = length(handles.MyData.Layers(ImPos).ROIS(:));
    else
        idx = 0; 
    end
    
        id = ['ROI' num2str(idx+1)];                                      % id genereres
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).ROIID = id; % id sættes
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).Location = pos; % Location sættes
         old = get(handles.lbT2Ana, 'string');
         ny = strvcat(char(old), char(handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).ROIID));
         set(handles.lbT2Ana,'string',ny);
  %       guidata(hObject, handles);
       
     
    else 
    id = ['ROI' num2str(1)];          % id genereres                                      
        handles.MyData.Layers(ImPos).ROIS.ROI(1).ROIID = id; % id sættes
        handles.MyData.Layers(ImPos).ROIS.ROI(1).Location = pos;
        set(handles.lbT2Ana,'string',{handles.MyData.Layers(ImPos).ROIS.ROI(1).ROIID});
end 
 
 end

