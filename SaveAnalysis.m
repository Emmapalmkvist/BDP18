function SaveAnalysis(handles)
%SAVEANALYSIS Gemmer en analyse som en .mat-fil, så den kan hentes ind og
%genoptages senere
%   Tjekker først og fremmest, om der er nogen data at gemme.
%   Hvis der er, så bedes brugeren om at specificere en sti og filnavn
%   Structet 'MyData' fra handles gemmes som en .mat-fil
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   Funktionen har ingen output argumenter, da den ikke ændrer på data
%   eller generer ny data

 if ~isfield(handles, 'MyData') || isempty(handles.MyData)
     msgbox('Der er ikke startet på nogen analyse')
     return;
 end
 
% Åbner en dialogbox hvor brugeren kan indskrive ønsket filnavn med .mat format. Herefter
% genereres fileName med fullfile ud fra PathName og FileName.
 Name = 'Analysis_';
 [FileName,PathName] = uiputfile('.mat','Hvor skal analysen gemmes?',Name);
 fileName = fullfile(PathName,FileName);
 
 if fileName ~= 0

    set(handles.figure1,'Pointer','watch'); % Ændrer cursor til watch 
    save(fileName,'-struct','handles','MyData')
    set(handles.figure1,'Pointer','arrow'); % Ændrer cursor til arrow
    
    % Notification til brugeren om filen er gemt
    msgbox(sprintf('Billedeanalyse er gemt i %s' , fileName), 'WindowStyle', 'modal');
end
end
