%dirName = uigetdir('PC', 'Vælg et bibliotek med Dicom filer');
%if dirName ~= 0
path = fullfile('C:\Users\IdaSofie\Desktop\Uni\6 semester\Biomedical Dataprocessing\Eksamen i BDP\ExamDICOMdata', 'P7');
files = dir(fullfile(path, '*.dcm'));
info = dicominfo(fullfile(path, files(1).name));

% 4-dimensionelt matrix
% 3 kanal har et et-tal fordi det er gråtone billeder
stack = cell(1,length(files));%
location = cell(1,length(files));
spacing= cell(1,length(files));
angle = cell(1, length(files));


for ii = 1:length(files)
    iminfo = dicominfo(fullfile(path, files(ii).name));
    im = double(dicomread(fullfile(path, files(ii).name)));
    % Normalisering
    im = im/max(im(:));
    stack{ii} = im;
    
    spacing{ii} = iminfo.SpacingBetweenSlices;
    location{ii} = iminfo.SliceLocation;
    angle{ii} = iminfo.FlipAngle;
    
    %
    %if(length(im) == 512)
    %stack512(:, :, 1, ii) = im;
    %elseif(length(im) == 256)
    %    stack256(:, :, 1, ii) = im;
    %end
    
end

location = location';

