function handles = sortLayers(handles)
%SORTLAYERS Sorts the T2* images into layers
%   Detailed explanation goes here

[uniValues, ~, layer] = unique([handles.MyData.T2.SliceLocation]);

handles.MyData.NumbOfLayers = length(uniValues);
layer = num2cell(layer);
[handles.MyData.T2.LayerNo] = deal(layer{:});

for i = 1:length(uniValues)
   antalBillederIsnit = length(handles.MyData.T2([handles.MyData.T2.LayerNo]==i));
   handles.MyData.Layers(i) = antalBillederIsnit;
   %length(handles.MyData.T2([handles.MyData.T2.LayerNo]==ii)) [sze, ~] =
   %size([handles.MyData.T2.Image]); 
   %stack = zeros(sze,sze,1,antalBillederIsnit);
   
   imag = handles.MyData.T2([handles.MyData.T2.LayerNo]==i);
   for ii = 1:antalBillederIsnit
       im = double(imag(ii).Image);
       %im = double(handles.MyData.T2(ii).Image); 
       im = im/max(im(:));
       handles.MyData.Stacks(i).Stack(:,:,1,ii) = im;
    
   end
 
end
end

