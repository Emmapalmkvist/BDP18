function SaveAnalysis(handles)
 if ~isfield(handles, 'MyData') || isempty(handles.MyData)
     msgbox('Der er ikke startet p� nogen analyse')
     return;
 end
 
% �bner en dialogbox hvor brugeren kan indskrive �nsket filnavn med .mat format. Herefter
% genereres fileName med fullfile ud fra PathName og FileName.
 Name = 'Analysis_';
 [FileName,PathName] = uiputfile('.mat','Hvor skal analysen gemmes?',Name);
 fileName = fullfile(PathName,FileName);
 
 if fileName ~= 0

    set(handles.figure1,'Pointer','watch'); % �ndrer cursor til watch 
    save(fileName,'-struct','handles','MyData')
    set(handles.figure1,'Pointer','arrow'); % �ndrer cursor til arrow
    
    % Notification til brugeren om filen er gemt
    msgbox(sprintf('Billedeanalyse er gemt i %s' , fileName));
end
end
