function handles = SaveResults(handles)

 if ~isfield(handles, 'MyData') || isempty(handles.MyData)
     msgbox('Der er ikke gennemførst nogen analyse')
     return;
 end
%Brugeren vælger navn og sti til filen 
[file, path] = uiputfile('*.txt', 'Vælg filnavn', 'T2værdier_');
fileName = fullfile(path, file);

%Danner filnavnen til filen
%[filepath,name,extension] = fileparts(filename); 
%resfilename = [name, '.txt']; 

%Opretter en fil med en identifier (fid)
fid = fopen(fileName, 'w'); % 'w' specifies write access' 

ImPos = (get(handles.SliderLayer, 'Value'));

%Udskriver resultaterne 
fprintf(fid, '*** Resultater for %s ***\r\n', file); 
fprintf(fid, 'Patientens CPR-nummer: %s \r\n', handles.MyData.PatientID);
fprintf(fid, 'T2* værdierne tilhører snit %d. \r\n', ImPos);
fprintf(fid, 'På dette snit %d er der indtegnet %d ROI. \r\n', (get(handles.SliderLayer, 'Value')), (length(handles.MyData.Layers(1).ROIS)));

for i = 1:length(handles.MyData.Layers(ImPos).ROIS(:))
    
    str = strjoin(handles.MyData.Layers(ImPos).ROIS(i).ROI.ROIID);
    fprintf(fid, 'T2* værdien for ROI %s er %f \r\n', str, (handles.MyData.Layers(ImPos).ROIS(i).ROI.T2));

end 
end

