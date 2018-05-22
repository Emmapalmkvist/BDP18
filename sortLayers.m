function handles = sortLayers(handles)
%SORTLAYERS Sorts the T2* images into layers
%   Detailed explanation goes here

[test, ~, layer] = unique([handles.MyData.T2.SliceLocation]);

handles.MyData.Layer = length(test);
layer = num2cell(layer);
[handles.MyData.T2.Layer] = deal(layer{:});
%handles.MyData.T2(:).Layer = {'Layer', indexInC(:)};
end

