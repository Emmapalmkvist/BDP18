function handles = CreateROIs(handles)
axes(handles.axDrawROI);            % Udvælgelse af axes der kan tegnes på.

% Tjekker om handles indeholde MyData eller om MyData er tom og 
% notificerer med messagebox og returnerer fra
% funktionen, hvis det er tilfældet.
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Indlæs venligst billede');
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
         handles.MyData.Layers(ImPos).ROIS(idx+1).ROI(1).Location = pos;  % Location sættes
    %    handles.MyData.Layers(strcmp({handles.MyData.Layers.ROIS.Id},id)).ROI = ROI;       % ROI sættes
     
    else 
    id = ['ROI' num2str(1)];          % id genereres                                      
        handles.MyData.Layers(ImPos).ROIS.ROI(1).ROIID = id; % id sættes
        handles.MyData.Layers(ImPos).ROIS.ROI(1).Location = pos;
        
      %  handles.MyData.Layers(ImPos).ROIS.ROI.Location = pos;    % Location sættes
      %  handles.MyData.Layers(ImPos).ROIS.ROI = ROI;
      
    
 %    handles.MyData.Layers(ImPos).ROIS.ROI(1).mean = mean;
end 

%Præallokering
% y = zeros(1, mValue);
% 
% for i = 1:mValue
%     image = double(handles.MyData.Layers(ImPos).Images(i).Image);
% 
%     % Find den del i image, som ROI'en indkranser
%     image(mask == 0) = 0;
% 
%     % Normalisér billedet
%     pic = image/max(image(:));
% 
%     % Tag middelværdi af værdierne i ROI'en
%     y(i) = mean(pic(:));
%     handles.MyData.Layers(ImPos).ROIS.ROI1.mean(i) = y(i);
% end
% 
% handles.MyData.Layers(ImPos).ROIS.pos = getPosition(handles.MyData.Layer(ImPos).ROIS);
% 
 end

