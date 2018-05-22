function handles = loadFiles(handles)
%LOADFILES Load files from a directory
%   handles is the handle from the GUI

dirName = uigetdir('PC', 'Vælg et bibliotek med Dicom filer');
if dirName ~= 0
    path = fullfile('E:\MATLAB\ExamDICOMdata', 'P7');
    files = dir(fullfile(path, '*.dcm'));
    
    CntT2 = 0;
    CntLoc = 0;
    
    for ii = 1:length(files)
        iminfo = dicominfo(fullfile(path, files(ii).name));
        if strfind(iminfo.SeriesDescription, 'T2')
            im = double(dicomread(fullfile(path, files(ii).name)));
            handles.MyData.T2(CntT2).Image = im/max(im(:));
            handles.MyData.T2(CntT2).SliceLocation = iminfo.SliceLocation;
            handles.MyData.T2(CntT2).SliceLocation = iminfo.EchoTime;
            CntT2 = CntT2 + 1;
        else
            im = double(dicomread(fullfile(path, files(ii).name)));
            handles.MyData.Loc(CntLoc).Image = im/max(im(:));
            handles.MyData.Loc(CntLoc).SliceLocation = iminfo.SliceLocation;
            handles.MyData.Loc(CntLoc).SliceLocation = iminfo.EchoTime;
            CntLoc = CntLoc + 1;
        end        
    end
end


end

