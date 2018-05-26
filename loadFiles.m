function handles = loadFiles(handles)
%LOADFILES Load files from a directory
%   handles is the handle from a GUI. The files are saved in MyData in handles, 
%   and is saved under T2 if it's a T2 image, or in Loc if it isn't a T2
%   image. The following things is added to MyData.T2/Loc
    % Image: the loaded dicom image
    % SliceLocation: the slice location for the current image
    % EchoTime = the echo time for the current image
    
handles = clearGUI(handles);
   
% Ask user to choose directory and if a directory is chosen, then save the
% image and relevant information as stated above
dirName = uigetdir('PC', 'Vælg et bibliotek med Dicom filer');
if dirName ~= 0
    files = dir(fullfile(dirName, '*.dcm'));
        
    % Counters for number of T2-images and number of Localizer images
    CntT2 = 1;
    CntLoc = 1;
    numberoffiles = length(files);

    wb = waitbar(0,'Henter DICOM-billeder');
    
    for ii = 1:length(files)
        currentFile = fullfile(dirName, files(ii).name);
        
        iminfo = dicominfo(currentFile);
        % Check the tag "SeriesDescription" to check if it's T2*
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
    handles.MyData.PatientID = iminfo.PatientID; 
     
   
end

