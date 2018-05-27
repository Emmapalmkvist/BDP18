function LoadSavedAnalysis(handles)

ImPos = get(handles.SliderLayer, 'Value');
if ~isempty(handles.MyData.Layers(ImPos))
    choice = questdlg('Der er allerede en analyse i gang der vil blive overskrevet. �nsker du at fors�tte?', ...
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
        % Data indl�ses og s�ttes i respektive handles
        savedData = load(fullfile(pathName,fileName));
        handles.MyData = savedData.MyData;

        
        
        wb = waitbar(0, 'Indl�ser valgte analyse...');
        set(wb,'WindowStyle', 'modal' );
      
                
        % Opretter en waitbar og s�tter den til modal, hvilket s�tter den
        % som forreste vindue.
    for ii = 1:length(handles.MyData)      
        waitbar(ii/length(handles.MyData), wb, sprintf('Indl�ser valgte analyse...'))  
    end
    
        displayLayers(handles);

        close(wb); 

end

