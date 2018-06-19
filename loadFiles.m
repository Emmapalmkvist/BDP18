function handles = loadFiles(handles)
%LOADFILES Henter filer fra en valgt mappe
%   handles bruges til at gennem indl�ste data i. Billederne gemmes i
%   MyData og opdeles i T2 og Loc efter deres DICOM information "SeriesDescription"
%   INPUT:
%   handles: handle til elementer i gui
%
%   OUTPUT:
%   handles med de indl�ste data i MyData.T2 og MyData.Loc
%   - Image: det indl�se DICOM billede
%   - SliceLocation: snitlokation for det nuv�rende billede
%   - EchoTime: ekkotiden for nuv�rende billedet
    
    

   
% Beder brugeren om at v�lge mappe. N�r mappen er valgt gemmes billederne
% og den tilh�rende udvalgte information. 
dirName = uigetdir('PC', 'V�lg et bibliotek med Dicom filer');
if dirName ~= 0
    handles = clearGUI(handles);
    files = dir(fullfile(dirName, '*.dcm'));
    % T�ller nummeret af T2-billeder og nummeret af Localizer billeder
    CntT2 = 1;
    CntLoc = 1;
    numberoffiles = length(files);

    wb = waitbar(0,'Henter DICOM-billeder');
    
    for ii = 1:length(files)
        currentFile = fullfile(dirName, files(ii).name);
        
        iminfo = dicominfo(currentFile);
        % Tjekker om "SeriesDescription" tagget er 'T2'
        if strfind(iminfo.SeriesDescription, 'T2')
            handles.MyData.T2(CntT2).Image = dicomread(currentFile);
            handles.MyData.T2(CntT2).SliceLocation = iminfo.SliceLocation;
            handles.MyData.T2(CntT2).EchoTime = iminfo.EchoTime;
            CntT2 = CntT2 + 1;
        else
            handles.MyData.Loc(CntLoc).Image = dicomread(currentFile);
            handles.MyData.Loc(CntLoc).SliceLocation = iminfo.SliceLocation;
            handles.MyData.Loc(CntLoc).EchoTime = iminfo.EchoTime;
            CntLoc = CntLoc + 1;     
        end 
        waitbar(ii/numberoffiles,wb);
    end
    if exist('wb','var')
    close(wb);
    end
    
    set(handles.txtPatient, 'String', iminfo.PatientID);
    set(handles.txtPatient,'Visible','on');
    handles.MyData.PatientID = iminfo.PatientID; 
  
   
end

