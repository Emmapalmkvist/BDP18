function handles = displayROIPicture(handles)
%DisplayROIPicture Viser billederne i det valgte snit i axes
%   
ImPos = ceil(get(handles.SliderLayer, 'Value'));
 ImPosROI = round(get(handles.SliderROIPicture, 'Value'));
 set(handles.txtSliderROIPicture, 'String', sprintf('%d/%d', ImPosROI, length(handles.MyData.Layers(ImPos).Images))); 
 axes(handles.axDrawROI)
 %Normalisering
 currentIm = double(handles.MyData.Layers(ImPos).Images(ImPosROI).Image);
 currentIm = currentIm./max(currentIm(:));
 imshow(currentIm);
end

