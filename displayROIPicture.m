function handles = displayROIPicture(handles)
%DISPLAYROIPICTURE viser hvert enkelt billede i det valgte snit.
%Hivlket billede der er vist skifter, når brugeren flytter på slideren.
    
 cla(handles.axDrawROI)

 layerPos = ceil(get(handles.SliderLayer, 'Value'));
 echoPos = round(get(handles.SliderROIPicture, 'Value'));
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

