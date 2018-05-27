function handles = sortLayers(handles)
%SORTLAYERS Sorts the T2* images into layers
%   Finder f�rst de unikke v�rdier i T2-billedernes SliceLocation. S�ledes
%   opdeles der i lag (T2.LayerNo).
%   Gemmer antallet af lag i handles (NumbOfLayers)
%   For hvert lag gemmes de tilh�rende billeder i handles (Layers.Images)
%   Hvert billede i et lag klarg�res til montage (Stacks.Stack)
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   handles med de nye v�rdier i MyData:
%       - NumbOfLayers: antallet af lag i billederne
%       - T2.LayerNo: v�rdi til hver enkel r�kke (billede) som
%       indikerer lagnummeret
%       - Layers: et struct med et struct i hver r�kke
%           - Layers.Images: et struct indeholdende billederne i det
%             respektive lag
%       - Stacks: et struct med 4-D i hver r�kke
%           - Stacks.Stack: en stak af billederne, klargjort til montage

% Bruger "unique" til at finde de unikke v�rdier i SliceLocation
[uniqueValues, ~, layer] = unique([handles.MyData.T2.SliceLocation]);

% Antallet af unikke v�rdier er antallet af lag
handles.MyData.NumbOfLayers = length(uniqueValues);
% Layer er en vektor med lag-numre. Denne g�res til en cell som kan
% placeres i et struct
layer = num2cell(layer);
% Indholdet i layer placeres i det tilh�rende field i structet
[handles.MyData.T2.LayerNo] = deal(layer{:});

% Alle lagene l�bes igennem
for i = 1:length(uniqueValues)
    % Sorter billederne i et snit efter stigende ekkotid ved at lave
    % structet om til et cell array og sorter p� den �nskede kolonne
    dataStruct = handles.MyData.T2([handles.MyData.T2.LayerNo]==i);
    fNames = fieldnames(dataStruct);
    dataCell = struct2cell(dataStruct);
    cellSize = size(dataCell);
    dataCell = reshape(dataCell, cellSize(1), []);
    dataCell = dataCell';
    % Sort�r efter kolonne 3, som er ekkotiden
    dataCell = sortrows(dataCell, 3);
    dataCell = reshape(dataCell', cellSize);
    
    % Alle billederne tilh�rende nuv�rende snit gemmes
    handles.MyData.Layers(i).Images = cell2struct(dataCell, fNames, 1);
    
    numbOfPics = length(handles.MyData.T2([handles.MyData.T2.LayerNo]==i));
    
    % Alle billederne i et lag l�bes igennem
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
