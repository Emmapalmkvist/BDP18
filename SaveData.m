function SaveData(handles)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Der er ingen analyse at gemme')
    return;
end

filnavn = 'analyse';
[file,path] = uiputfile({'*.mat','CSV-filer'},'Gem data som', filnavn');
filnavn = fullfile(path,file);
save(filnavn,'-struct','handles','MyData')

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