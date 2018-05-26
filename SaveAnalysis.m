function SaveAnalysis(handles)
 if ~isfield(handles, 'MyData') || isempty(handles.MyData)
     msgbox('Der er ikke startet på nogen analyse')
     return;
 end
 
% Åbner en dialogbox hvor brugeren kan indskrive ønsket filnavn med .mat format. Herefter
% genereres fileName med fullfile ud fra PathName og FileName.
 GFPname = ['Analysis_' handles.MyData.Layers.fileName];
 [FileName,PathName] = uiputfile('.mat','Hvor skal analysen gemmes?',GFPname);
 fileName = fullfile(PathName,FileName);
 
 if fileName ~= 0

    set(handles.figure1,'Pointer','watch'); % Ændre cursor til watch 
    % Gemmer handles.cellData og handles.imgData
    save(fileName,'-struct','handles','MyData')
    set(handles.figure1,'Pointer','arrow'); % Ændre cursor til arrow
    
    % Notification til brugeren om filen er gemt
    msgbox(sprintf('Billedeanalyse er gemt i %s' , fileName), 'WindowStyle', 'modal');
end
end
