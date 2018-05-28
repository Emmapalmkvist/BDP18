function SaveAnalysis(handles)
%SAVEANALYSIS Gemmer en analyse som en .mat-fil, s� den kan hentes ind og
%genoptages senere
%   Tjekker f�rst og fremmest, om der er nogen data at gemme.
%   Hvis der er, s� bedes brugeren om at specificere en sti og filnavn
%   Structet 'MyData' fra handles gemmes som en .mat-fil
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   Funktionen har ingen output argumenter, da den ikke �ndrer p� data
%   eller generer ny data

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
    msgbox(sprintf('Billedeanalyse er gemt i %s' , fileName), 'WindowStyle', 'modal');
end
end
