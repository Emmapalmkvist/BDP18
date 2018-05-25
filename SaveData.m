function SaveData(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~isfield(handles, 'Layers') || isempty(handles.MyData)
    msgbox('Der er ingen analyse at gemme')
    return;
end

% Åbner en dialogbox hvor brugeren kan indskrive ønsket filnavn med .mat format. Herefter
% genereres fileName med fullfile ud fra PathName og FileName.
GFPname = ['FullAnalysis_' handles.MyData.Layers.fileName];
[FileName,PathName] = uiputfile('.mat','Hvor skal analysen gemmes?',GFPname);
fileName = fullfile(PathName,FileName);
end

