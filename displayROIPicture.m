function handles = displayROIPicture(handles)
%DISPLAYROIPICTURE viser hvert enkelt billede i det valgte snit.
%   Hvilket billede der er vist skifter, når brugeren flytter på slideren.
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   handles med nye værdier i MyData:
%   - HandleToCurrentROIImage: et handle til det nuværende, viste billede.
%     Bruges senere til oprettelse af maske for nye ROIs
    
 cla(handles.axDrawROI)

 layerPos = ceil(get(handles.SliderLayer, 'Value'));
 %Udkommenteret efter aflevering: echoPos = round(get(handles.SliderROIPicture, 'Value'));
 %Ændret til ceil
 echoPos = ceil(get(handles.SliderROIPicture, 'Value'));
 set(handles.txtSliderROIPicture, 'String', sprintf('%d/%d', echoPos,...
     length(handles.MyData.Layers(layerPos).Images))); 
 axes(handles.axDrawROI)
 %Normalisering
 currentIm = double(handles.MyData.Layers(layerPos).Images(echoPos).Image);
 currentIm = currentIm./max(currentIm(:));
 handles.MyData.HandleToCurrentROIImage = imshow(currentIm);
 
  if isfield(handles.MyData.Layers,'ROIS')
        displayROISonPicture(handles);
  end  
end

