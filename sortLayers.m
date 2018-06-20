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
%(det skal vi ikke bruge og derfor ~) og giver snitene numre ud fra antallet
%af unikke værdier.
[uniqueValues, ~, layer] = unique([handles.MyData.T2.SliceLocation]);

% Antallet af unikke værdier er antallet af snit
handles.MyData.NumbOfLayers = length(uniqueValues);
% Layer er en vektor med snit-numre. Denne gøres til en cell som kan
% placeres i et struct
layer = num2cell(layer);
% opretter en kolonne i structet, hvor layer kommer til at ligge på layerno
[handles.MyData.T2.LayerNo] = deal(layer{:});

% Alle snitene løbes igennem - således at billederne i ét snit
% sorteres
for i = 1:length(uniqueValues)
    % Sorterer billederne i et snit efter stigende ekkotid ved at lave
    % structet om til et cell array og sorterer på den ønskede kolonne
        
    % i structet findes de rækker, som tilhører det i'ne snit
    dataStruct = handles.MyData.T2([handles.MyData.T2.LayerNo]==i);
    % fieldnames gemmes -  egentlig bare for at vi har dem, men vi ved at
    % det er 3. kolonne vi vil sortere på, for det er echotiden. 
    fNames = fieldnames(dataStruct);
    % Konverter fra struct til cellarray, så der kan sorteres
    dataCell = struct2cell(dataStruct);
    % Find størrelsen: [4 1 16] = 4 rækker, 1 kolonne, data i 3. dimension
    % (16 billeder = 16 felter)
    cellSize = size(dataCell);
    % Reshape for at forme arrayet om til matrix form
    % elementerne fra dataCell tages og laves til en matrix
    dataCell = reshape(dataCell, cellSize(1), []);
    % Transponerer = vender matricen, så det ligner structet
    dataCell = dataCell';
    % Sortér efter kolonne 3, som er ekkotiden
    dataCell = sortrows(dataCell, 3);
    % Reshape tilbage til cell-form
    dataCell = reshape(dataCell', cellSize);
     % Alle billederne tilhørende nuværende snit gemmes
     % konvertér tilbage til struct
    handles.MyData.Layers(i).Images = cell2struct(dataCell, fNames, 1);
   
    % NB: Efter aflevering: structet kunne laves direkte til en tabel
    % (struct2table)og så sortere efter en kolonne, og så tilbage til
    % struct (table2struct)
    % Det vi har gjort er hvis vi havde arbejdet med MATLAB før R2013b.
    % https://se.mathworks.com/matlabcentral/answers/397385-how-to-sort-a-structure-array-based-on-a-specific-field
    
       
    numbOfPics = length(handles.MyData.T2([handles.MyData.T2.LayerNo]==i));
    
    % Alle billederne i et lag løbes igennem
    for ii = 1:numbOfPics
        % Billedet hentes og normaliseres, for at gemmes i en stack til
        % montage
        im = double(handles.MyData.Layers(i).Images(ii).Image);
        im = im/max(im(:));
        %handles.MyData.Stacks(i).Stack(:,:,1,ii) = im;
        %billedet laves på 'stack-form', så vi kan lave en montage
        handles.MyData.Layers(i).Stack(:,:,1,ii) = im;
    end
    
end
end

% Sortering foretaget med inspiration fra: https://blogs.mathworks.com/pick/2010/09/17/sorting-structure-arrays-based-on-fields/
