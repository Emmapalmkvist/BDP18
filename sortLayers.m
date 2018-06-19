function handles = sortLayers(handles)
%SORTLAYERS Sorterer T2* billederne i snit
%   Finder først de unikke værdier i T2-billedernes SliceLocation. Således
%   opdeles der i lag (T2.LayerNo).
%   Gemmer antallet af lag i handles (NumbOfLayers)
%   For hvert lag gemmes de tilhørende billeder i handles (Layers.Images)
%   Hvert billede i et snit klargøres til montage (Layers.Stack)
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
%           - Layers.Stack: en stak af billederne i snittet - klargjort til
%             montage

% Bruger "unique" til at finde de unikke værdier i SliceLocation
%unique giver de unikke værdier, giver hvor de unikke værdier er placeret
%(det skal vi ikke bruge og derfor ~) og giver lagne numre ud fra antallet
%af unikke værdier.
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
    % Sorter billederne i et snit efter stigende ekkotid ved at lave
    % structet om til et cell array og sorter på den ønskede kolonne
    dataStruct = handles.MyData.T2([handles.MyData.T2.LayerNo]==i);
    fNames = fieldnames(dataStruct);
    dataCell = struct2cell(dataStruct);
    cellSize = size(dataCell);
    dataCell = reshape(dataCell, cellSize(1), []);
    dataCell = dataCell';
    % Sortér efter kolonne 3, som er ekkotiden
    dataCell = sortrows(dataCell, 3);
    dataCell = reshape(dataCell', cellSize);
    
    % Alle billederne tilhørende nuværende snit gemmes
    handles.MyData.Layers(i).Images = cell2struct(dataCell, fNames, 1);
    
    numbOfPics = length(handles.MyData.T2([handles.MyData.T2.LayerNo]==i));
    
    % Alle billederne i et lag løbes igennem
    for ii = 1:numbOfPics
        % Billedet hentes og normaliseres, for at gemmes i en stack til
        % montage
        im = double(handles.MyData.Layers(i).Images(ii).Image);
        im = im/max(im(:));
        %handles.MyData.Stacks(i).Stack(:,:,1,ii) = im;
        handles.MyData.Layers(i).Stack(:,:,1,ii) = im;
    end
    
end
end

% Sortering foretaget med inspiration fra: https://blogs.mathworks.com/pick/2010/09/17/sorting-structure-arrays-based-on-fields/
