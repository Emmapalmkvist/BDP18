function SaveData(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Der er ingen analyse at gemme')
    return;
end

% Åbner en dialogbox hvor brugeren kan indskrive ønsket filnavn med .mat format. Herefter
% genereres fileName med fullfile ud fra PathName og FileName.
GFPname = ['FullAnalysis_' handles.MyData.Layers.fileName];
[FileName,PathName] = uiputfile('.mat','Hvor skal analysen gemmes?',GFPname);
fileName = fullfile(PathName,FileName);c
end

%save(filnavn);

%  output{1} = 'emma'; %handles.MyData.Layers;
% %    output(2:3) = {handles.MyData.Layers(1).ROIS.ROI.ROIID, handles.MyData.Layers(1).ROIS.ROI.ROIID};
% 
%     % Data gemmes i en csv fil med navne til variablerne
%     outputTable = cell2table(output,'VariableNames',{'Images'});
%     writetable(outputTable,fullfile(file,path), 'Delimiter',';');
    
        % Notification til brugeren om filen er gemt
    
        msgbox(sprintf('Billedeanalyse er gemt i %s' , filnavn), 'WindowStyle', 'modal');
end
