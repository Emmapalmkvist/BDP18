function LoadSavedAnalysis(handles)

ImPos = get(handles.SliderLayer, 'Value');
if ~isempty(handles.MyData.Layers(ImPos))
    choice = questdlg('Der er allerede en analyse i gang der vil blive overskrevet. Ønsker du at forsætte?', ...
    'Overskrivning af analyse', ...
    'Ja','Nej','Ja');

    switch choice
        case 'Ja'

        case 'Nej'
            return
    end
end 

[fileName, pathName] = uigetfile('*.mat');

    if fileName ~= 0
        % Data indlæses og sættes i respektive handles
        savedData = load(fullfile(pathName,fileName));
        handles.MyData = savedData.MyData;

        
        
        wb = waitbar(0, 'Indlæser valgte analyse...');
        set(wb,'WindowStyle', 'modal' );
        
    for ii = 1:length(handles.MyData)      
        waitbar(ii/length(handles.MyData), wb, sprintf('Indlæser valgte analyse'))  
    end
    
        displayLayers(handles);
        displayROIPicture(handles);
%Hvis den ikke viser ROIS, så mangler vi at kalde den metode... 
        
                % Opretter en waitbar og sætter den til modal, hvilket sætter den
        % som forreste vindue.
        close(wb); 

end

