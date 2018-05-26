function SaveAnalysis(handles)
 if ~isfield(handles, 'MyData') || isempty(handles.MyData)
     msgbox('Der er ikke startet på nogen analyse')
     return;
 end
 
% Åbner en dialogbox hvor brugeren kan indskrive ønsket filnavn med .mat format. Herefter
% genereres fileName med fullfile ud fra PathName og FileName.
 GFPname = ['FullAnalysis_' handles.MyData.Layers.fileName];
 [FileName,PathName] = uiputfile('.mat','Hvor skal analysen gemmes?',GFPname);
 fileName = fullfile(PathName,FileName);

end
