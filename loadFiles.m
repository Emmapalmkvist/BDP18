function handles = loadFiles(handles)
%LOADFILES Henter filer fra en valgt mappe
%   handles bruges til at gennem indlæste data i. Billederne gemmes i
%   MyData og opdeles i T2 og Loc efter deres DICOM information "SeriesDescription"
%   INPUT:
%   handles: handle til elementer i gui
%
%   OUTPUT:
%   handles med de indlæste data i MyData.T2 og MyData.Loc
%   - Image: det indlæse DICOM billede
%   - SliceLocation: snitlokation for det nuværende billede
%   - EchoTime: ekkotiden for nuværende billedet
    
    

   
% Beder brugeren om at vælge mappe. Når mappen er valgt gemmes billederne
% og den tilhørende udvalgte information.
%propmter brugeren til at vælge et bibliotek med dicom-billeder
% hvis der er en mappe der hedder PC på computeren, åbnes den mappe
dirName = uigetdir('PC', 'Vælg et bibliotek med Dicom filer');  
if dirName ~= 0 %hvis man ikke har trykket annuller eller lukket dialogboksen 
    handles = clearGUI(handles);
    %dir tager directory, der tager de filer i den mappe der har .dcm
    %fullfile er for at undgå at skrive selve stien, her kan det gøres på
    %både mac og window.
    files = dir(fullfile(dirName, '*.dcm'));
    % Tæller nummeret af T2-billeder og nummeret af Localizer billeder
    CntT2 = 1;
    CntLoc = 1;
    %Til waitbaren
    numberoffiles = length(files);

    %starter ved 0
    wb = waitbar(0,'Henter DICOM-billeder');
    
    for ii = 1:length(files)
        %navnet på mappen, navnet på filen
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
    % tjekker om wb findes som varibel (for hvis den ikke gør, har brugeren
    % lukket den 
    if exist('wb','var')
    close(wb);
    end
    
    set(handles.txtPatient, 'String', iminfo.PatientID);
    % Gør tekstboksen synlig, når der er kommet data
    set(handles.txtPatient,'Visible','on');
    handles.MyData.PatientID = iminfo.PatientID; 
end

