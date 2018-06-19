function SaveResults(handles)
%SAVERESULTS Denne funktion gemmer en analyse i en txt-fil som brugeren kan finde frem
% efter analysen er foretaget og programmet er lukket.
%   Tjekker f�rst og fremmest, om der er nogen data at gemme.
%   Hvis der er, s� bedes brugeren om at specificere en sti og filnavn
%   Text-filen oprettes/�bnes og udvalgte data gemmes deri
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   Funktionen har ingen output argumenter, da den ikke �ndrer p� data
%   eller generer ny data

if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Der er ikke gennemf�rt nogen analyse')
    return;
end

if ~isfield(handles.MyData.Layers, 'ROIS')
    msgbox('Der er ikke gennemf�rt nogen analyse.');
else
    
    %Brugeren v�lger navn og sti til filen
    [file, path] = uiputfile('*.txt', 'V�lg filnavn', 'T2v�rdier_');
    fileName = fullfile(path, file);
    
    % Der returneres 0, hvis brugeren annullerer 
    if fileName ~= 0
        
        %Opretter en fil med en identifier (fid)
        fid = fopen(fileName, 'w'); % 'w' specifies write access'
        
        % Finder snitposition
        layerPos = (get(handles.SliderLayer, 'Value'));
        
        %Udskriver resultaterne
        fprintf(fid, '*** Resultater for %s ***\r\n', file);
        fprintf(fid, 'Patientens CPR-nummer: %s \r\n', handles.MyData.PatientID);
        
        fprintf(fid, 'T2* v�rdierne tilh�rer snit %d. \r\n', layerPos);
        fprintf(fid, 'P� dette snit %d er der indtegnet %d ROI. \r\n',...
            (get(handles.SliderLayer, 'Value')), (length(handles.MyData.Layers(1).ROIS)));
        
        for i = 1:length(handles.MyData.Layers(layerPos).ROIS(:))
            
            % strjoin: for at vi kan f� v�rdien ud fra cellen: cellev�rdien
            % laves om til en string
            str = strjoin(handles.MyData.Layers(layerPos).ROIS(i).ROI.ROIID);
            % Kan ogs� g�res ved:
            % cell = handles.MyData.Layers(layerPos).ROIS(i).ROI.ROIID;
            % string = cell{1}; s�ledes at der tilg�s den f�rste celle i
            % cellarrayet
            
            fprintf(fid, 'T2* v�rdien for ROI %s er %.2f \r\n', str,...
                (handles.MyData.Layers(layerPos).ROIS(i).ROI.T2));
            
            % Tjekker, om der er en revideret T2*-v�rdi
            if isfield(handles.MyData.Layers(layerPos).ROIS(i).ROI, 'RevideretT2')
                fprintf(fid, 'Den revideret T2* v�rdi for ROI %s er %.2f \r\n',...
                    str, (handles.MyData.Layers(layerPos).ROIS(i).ROI.RevideretT2));
            end
        end
        
        %NB: TILF�JET EFTER AFLEVERING        
        fclose(fid);
        % S�rg for at lukke filen, s� den ikke bruges af MATLAB l�ngere
        
    end
    % Notification til brugeren om filen er gemt 
    % NB: b�r flyttes ind i if
    msgbox(sprintf('Billedeanalyse er gemt i %s.' , fileName));
end
end

