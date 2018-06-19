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
%ceil runder op til næste heltal, da get kan give kommatal.
 layerPos = ceil(get(handles.SliderLayer, 'Value'));
 %Udkommenteret efter aflevering: echoPos = round(get(handles.SliderROIPicture, 'Value'));
 % round er ændret til ceil
 echoPos = ceil(get(handles.SliderROIPicture, 'Value'));
 set(handles.txtSliderROIPicture, 'String', sprintf('%d/%d', echoPos,...
     length(handles.MyData.Layers(layerPos).Images))); 
 axes(handles.axDrawROI)
 %Normalisering - ellers ville det giver et gråt billede at de 12-bit ikke
 %udnytter at det vises i 16-bit
 currentIm = double(handles.MyData.Layers(layerPos).Images(echoPos).Image);
 currentIm = currentIm./max(currentIm(:));
 %Gemmer handle til billedet, så det kan bruges senere. 
 handles.MyData.HandleToCurrentROIImage = imshow(currentIm);
 
  if isfield(handles.MyData.Layers,'ROIS')
        displayROISonPicture(handles);
  end  
end

