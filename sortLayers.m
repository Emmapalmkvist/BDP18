function handles = sortLayers(handles)
%SORTLAYERS Sorts the T2* images into layers
%   Detailed explanation goes here

[uniValues, ~, layer] = unique([handles.MyData.T2.SliceLocation]);

handles.MyData.NumbOfLayers = length(uniValues);
layer = num2cell(layer);
[handles.MyData.T2.LayerNo] = deal(layer{:});

end

