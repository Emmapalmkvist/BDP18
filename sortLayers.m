function handles = sortLayers(handles)
%SORTLAYERS Sorts the T2* images into layers
%   Detailed explanation goes here

[uniqueValues, ~, layer] = unique([handles.MyData.T2.SliceLocation]);

handles.MyData.NumbOfLayers = length(uniqueValues);
layer = num2cell(layer);
[handles.MyData.T2.LayerNo] = deal(layer{:});

for i = 1:length(uniqueValues)
   handles.MyData.Layers(i).Images = handles.MyData.T2([handles.MyData.T2.LayerNo]==i);
   numbOfPics = length(handles.MyData.T2([handles.MyData.T2.LayerNo]==i));
   
   %imag = handles.MyData.T2([handles.MyData.T2.LayerNo]==i);
   for ii = 1:numbOfPics
       
       im = double(handles.MyData.Layers(i).Images(ii).Image);
       %im = double(handles.MyData.T2(ii).Image); 
       im = im/max(im(:));
       handles.MyData.Stacks(i).Stack(:,:,1,ii) = im;
    
   end
 
end
end

