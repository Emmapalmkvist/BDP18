function SaveResults(handles)

%Denne funktion gemmer en analyse i en txt-fil som brugeren kan finde frem
% efter analysen er foretaget og programmet er lukket.

if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Der er ikke gennemf�rst nogen analyse')
    return;
end
%Brugeren v�lger navn og sti til filen
[file, path] = uiputfile('*.txt', 'V�lg filnavn', 'T2v�rdier_');
fileName = fullfile(path, file);

if fileName ~= 0
    
    %Opretter en fil med en identifier (fid)
    fid = fopen(fileName, 'w'); % 'w' specifies write access'
    
    ImLayer = (get(handles.SliderLayer, 'Value'));
    
    %Udskriver resultaterne
    fprintf(fid, '*** Resultater for %s ***\r\n', file);
    fprintf(fid, 'Patientens CPR-nummer: %s \r\n', handles.MyData.PatientID);
    
    if isfield(handles.MyData.Layers, 'ROIS')
        fprintf(fid, 'T2* v�rdierne tilh�rer snit %d. \r\n', ImLayer);
        fprintf(fid, 'P� dette snit %d er der indtegnet %d ROI. \r\n', (get(handles.SliderLayer, 'Value')), (length(handles.MyData.Layers(1).ROIS)));
        
        for i = 1:length(handles.MyData.Layers(ImLayer).ROIS(:))
            
            str = strjoin(handles.MyData.Layers(ImLayer).ROIS(i).ROI.ROIID);
            fprintf(fid, 'T2* v�rdien for ROI %s er %.2f \r\n', str, (handles.MyData.Layers(ImLayer).ROIS(i).ROI.T2));
            fprintf(fid, 'Den revideret T2* v�rdi for ROI %s er %.2f \r\n', str, (handles.MyData.Layers(ImLayer).ROIS(i).ROI.RevideretT2));
        end
    end
    % Notification til brugeren om filen er gemt
    msgbox(sprintf('Billedeanalyse er gemt i %s' , fileName), 'WindowStyle', 'modal');
end
end

