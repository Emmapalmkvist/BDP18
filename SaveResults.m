function SaveResults(handles)
%SAVERESULTS Denne funktion gemmer en analyse i en txt-fil som brugeren kan finde frem
% efter analysen er foretaget og programmet er lukket.
%   Tjekker først og fremmest, om der er nogen data at gemme.
%   Hvis der er, så bedes brugeren om at specificere en sti og filnavn
%   Text-filen oprettes/åbnes og udvalgte data gemmes deri
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   Funktionen har ingen output argumenter, da den ikke ændrer på data
%   eller generer ny data

if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Der er ikke gennemført nogen analyse')
    return;
end

if ~isfield(handles.MyData.Layers, 'ROIS')
    msgbox('Der er ikke gennemført nogen analyse.');
else
    
    %Brugeren vælger navn og sti til filen
    [file, path] = uiputfile('*.txt', 'Vælg filnavn', 'T2værdier_');
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
        
        fprintf(fid, 'T2* værdierne tilhører snit %d. \r\n', layerPos);
        fprintf(fid, 'På dette snit %d er der indtegnet %d ROI. \r\n',...
            (get(handles.SliderLayer, 'Value')), (length(handles.MyData.Layers(1).ROIS)));
        
        for i = 1:length(handles.MyData.Layers(layerPos).ROIS(:))
            
            % strjoin: for at vi kan få værdien ud fra cellen: celleværdien
            % laves om til en string
            str = strjoin(handles.MyData.Layers(layerPos).ROIS(i).ROI.ROIID);
            % Kan også gøres ved:
            % cell = handles.MyData.Layers(layerPos).ROIS(i).ROI.ROIID;
            % string = cell{1}; således at der tilgås den første celle i
            % cellarrayet
            
            fprintf(fid, 'T2* værdien for ROI %s er %.2f \r\n', str,...
                (handles.MyData.Layers(layerPos).ROIS(i).ROI.T2));
            
            % Tjekker, om der er en revideret T2*-værdi
            if isfield(handles.MyData.Layers(layerPos).ROIS(i).ROI, 'RevideretT2')
                fprintf(fid, 'Den revideret T2* værdi for ROI %s er %.2f \r\n',...
                    str, (handles.MyData.Layers(layerPos).ROIS(i).ROI.RevideretT2));
            end
        end
        
        %NB: TILFØJET EFTER AFLEVERING        
        fclose(fid);
        % Sørg for at lukke filen, så den ikke bruges af MATLAB længere
        
    end
    % Notification til brugeren om filen er gemt 
    % NB: bør flyttes ind i if
    msgbox(sprintf('Billedeanalyse er gemt i %s.' , fileName));
end
end

