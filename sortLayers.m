function handles = sortLayers(handles)
%SORTLAYERS Sorts the T2* images into layers
%   Finder først de unikke værdier i T2-billedernes SliceLocation. Således
%   opdeles der i lag (T2.LayerNo).
%   Gemmer antallet af lag i handles (NumbOfLayers)
%   For hvert lag gemmes de tilhørende billeder i handles (Layers.Images)
%   Hvert billede i et lag klargøres til montage (Stacks.Stack)
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   handles med de nye værdier i MyData:
%       - NumbOfLayers: antallet af lag i billederne
%       - T2.LayerNo: værdi til hver enkel række (billede) som
%       indikerer lagnummeret
%       - Layers: et struct med et struct i hver række
%           - Layers.Images: et struct indeholdende billederne i det
%             respektive lag
%       - Stacks: et struct med 4-D i hver række
%           - Stacks.Stack: en stak af billederne, klargjort til montage

% Bruger "unique" til at finde de unikke værdier i SliceLocation
[uniqueValues, ~, layer] = unique([handles.MyData.T2.SliceLocation]);

% Antallet af unikke værdier er antallet af lag
handles.MyData.NumbOfLayers = length(uniqueValues);
% Layer er en vektor med lag-numre. Denne gøres til en cell som kan
% placeres i et struct
layer = num2cell(layer);
% Indholdet i layer placeres i det tilhørende field i structet
[handles.MyData.T2.LayerNo] = deal(layer{:});

% Alle lagene løbes igennem
for i = 1:length(uniqueValues)
    % Alle billederne tilhørende nuværende lag gemmes
    handles.MyData.Layers(i).Images = handles.MyData.T2([handles.MyData.T2.LayerNo]==i);
    numbOfPics = length(handles.MyData.T2([handles.MyData.T2.LayerNo]==i));
    
    % Alle billederne i et lag løbes igennem
    for ii = 1:numbOfPics
        % Billedet hentes og normaliseres, for at gemmes i en stack
        im = double(handles.MyData.Layers(i).Images(ii).Image);
        im = im/max(im(:));
        handles.MyData.Stacks(i).Stack(:,:,1,ii) = im;
    end
    
end
end

