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
%propmter brugeren til at v�lge et bibliotek med dicom-billeder
% hvis der er en mappe der hedder PC p� computeren, �bnes den mappe
dirName = uigetdir('PC', 'V�lg et bibliotek med Dicom filer');  
if dirName ~= 0 %hvis man ikke har trykket annuller eller lukket dialogboksen 
    handles = clearGUI(handles);
    %dir tager directory, der tager de filer i den mappe der har .dcm
    %fullfile er for at undg� at skrive selve stien, her kan det g�res p�
    %b�de mac og window.
    files = dir(fullfile(dirName, '*.dcm'));
    % T�ller nummeret af T2-billeder og nummeret af Localizer billeder
    CntT2 = 1;
    CntLoc = 1;
    %Til waitbaren
    numberoffiles = length(files);

    %starter ved 0
    wb = waitbar(0,'Henter DICOM-billeder');
    
    for ii = 1:length(files)
        %navnet p� mappen, navnet p� filen
        currentFile = fullfile(dirName, files(ii).name);
        
        % giver alt information omkring filen
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
    % tjekker om wb findes som varibel (for hvis den ikke g�r, har brugeren
    % lukket den 
    if exist('wb','var')
    close(wb);
    end
    
    set(handles.txtPatient, 'String', iminfo.PatientID);
    % G�r tekstboksen synlig, n�r der er kommet data
    set(handles.txtPatient,'Visible','on');
    handles.MyData.PatientID = iminfo.PatientID; 
end

