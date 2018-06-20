function handles = LoadSavedAnalysis(handles)
%LOADSAVEDANALYSIS Indhenter .mat fil med en gemt analyse
%   Tjekker først om der er eksisterende data til GUI'en
%   Derefter bedes brugeren vælge den ønskede analyse, der skal hentes ind
%   Filen læses ind og gemmes i handles, og oplysninger lægges ud på
%   brugergrænsefladen
%
%   INPUT:
%   handles: handle til elementer i gui
%
%   OUTPUT:
%   handles med de indlæste data i MyData

% Tjekker om der allerede er indhold hentet ind
if isfield(handles, 'MyData')
    layerPos = get(handles.SliderLayer, 'Value');
    if ~isempty(handles.MyData.Layers(layerPos))
        % Prompter brugeren med en spørgsmålboks
        % questdlg(SPØRGSMÅL, TITEL, KNAP1, KNAP2, DEFAULTKNAP) 
        choice = questdlg('Der er allerede en analyse i gang der vil blive overskrevet. Ønsker du at forsætte?', ...
            'Overskrivning af analyse', ...
            'Ja','Nej','Ja');
        
        switch choice
            case 'Ja'
                % Fortsættes der
            case 'Nej'
                return
                % Returneres, så nedenstående kode ikke udføres
        end
    end
end

% Vælg en matfil
[fileName, pathName] = uigetfile('*.mat');
% Trykkes der ikke annuller:
if fileName ~= 0
    handles = clearGUI(handles);
    % Opretter en waitbar og sætter den til modal, hvilket sætter
    % waitbar som forreste vindue.
    wb = waitbar(0, 'Indlæser analysens billeder...');
    set(wb,'WindowStyle', 'modal' );
    
    % Data indlæses og gemmes i handles
    savedData = load(fullfile(pathName,fileName));
    % Lægger MyData fra den hentede fil over i handles.MyData
    handles.MyData = savedData.MyData;
    % isvalid tjekker, om wb er valid: ikke er slettet eller er
    % uinitialiseret
    if isvalid(wb)
        waitbar(1/3, wb, sprintf('Indlæser analysens billeder...'))
    end
    
    % Gør brugergrænsefladen klar
    set(handles.SliderLayer, 'Value', 1);
    set(handles.SliderROIPicture, 'Value', 1);
    handles = initialiseSliders(handles);
    displayLayers(handles);
    
     % isvalid tjekker, om wb er valid: ikke er slettet eller er
    % uinitialiseret
    if isvalid(wb)
        waitbar(2/3, wb, sprintf('Indlæser analysens billeder...'))
    end
    
    % Tjekker om der er ROIs, der skal indlæses
    if isfield(handles.MyData.Layers, 'ROIS')
        % Har vi egentlig lige sat til 1, men hvis nu ombestemmer os en
        % anden gang - så skal vi ikke ændre flere steder
        layerPos = get(handles.SliderLayer, 'Value');
        % Placerer gemte ROIs i brugergrænsefladen
        displayROISonPicture(handles);
        if isvalid(wb)
            waitbar(3/3, wb, sprintf('Indlæser analysens billeder...'))
            close(wb)
        end
        
        %Finder ud af, hvor mange ROIs der er
        numbROIs = length(handles.MyData.Layers(layerPos).ROIS(:));
        
        if numbROIs ~= 0
            % Opretter en waitbar og sætter den til modal, hvilket sætter
            % waitbar som forreste vindue.
            wb = waitbar(0, 'Indlæser valgte analyse...');
            set(wb,'WindowStyle', 'modal' );
            % Laver variabel til waitbar - skal tælles op i forløkke, men der
            % er også en plot-metode senere, som kan tage lidt tid samt mulig
            % indhentning af revideret T2*-værdi.
            approxDuration = numbROIs + 1;
            
            % Enable groupbox der viser T2*-værdi og ROIs
            set(findall(handles.GroupT2Ana, '-property', 'enable'), 'enable', 'on');
            for i = 1:numbROIs
                oldList = get(handles.lbT2Ana, 'String');
                % strvcat: kobler gammel liste og ny ROI sammen, ved at
                % lave en 'character matrix' med teksten som rækker
                newList = strvcat(char(oldList), char(handles.MyData.Layers(layerPos).ROIS(i).ROI(1).ROIID));
                % Sætter listen i listboksen
                set(handles.lbT2Ana, 'String', newList);
                if isvalid(wb)
                    waitbar(i/approxDuration, wb, sprintf('Indlæser valgte analyse...'))
                end
            end
            
            % Sørger for, at den sidste ROI er markeret i listboksen
            set(handles.lbT2Ana, 'Value', numbROIs);
            
            % Fylder T2*-værdi og graf ind i brugergrænsefladen
            T2 = handles.MyData.Layers(layerPos).ROIS(numbROIs).ROI.T2;
            set(handles.txtT2, 'String', round(T2, 2));
            
            % Henter oplysninger til plot
            x = [handles.MyData.Layers(layerPos).Images.EchoTime]';
            y = [handles.MyData.Layers(layerPos).ROIS(numbROIs).ROI.MeanValue]';
            f = handles.MyData.Layers(layerPos).ROIS(numbROIs).ROI.FitData;
            axes(handles.axT2Graph)
            plot(f, x, y);
            set(get(handles.axT2Graph, 'ylabel'), 'string', 'Middelintensitet');
            set(get(handles.axT2Graph, 'xlabel'), 'string', 'Ekkotid [ms]');
            
            % Tjekker om der også er foretaget en pixelvis fitning
            if isfield(handles.MyData.Layers(layerPos).ROIS(numbROIs).ROI(1).EchoPix, 'T2')
                % Vis min-værdi ude i GUI (default er valgt som R^2) samt samt aktivér
                % plus-knap og deaktivér minus-knap
                set(findall(handles.GroupChoices, '-property', 'enable'), 'enable', 'on');
                set(handles.etExcludePixels, 'enable', 'off');
                set(handles.btnGrpExclude, 'SelectedObject', handles.rbR2);
                set(handles.etExcludePixels, 'String', num2str(round(minR2, 2)));
                set(handles.btnExcludePlus, 'enable', 'on');
                set(handles.btnExcludeMinus, 'enable', 'off');
                
                % Tjekker om der er udregnet en revideret T2*
                if isfield(handles.MyData.Layers(layerPos).ROIS(numbROIs).ROI(1), 'RevideretT2')
                    T2 = handles.MyData.Layers(layerPos).ROIS(ROIidx).ROI.RevideretT2;
                    set(handles.txtT2Revideret, 'String', round(T2, 2));
                end
                
                if isvalid(wb)
                    waitbar(approxDuration/approxDuration, wb, sprintf('Indlæser valgte analyse...'))
                end
            end
        end
    else
        if isvalid(wb)
        waitbar(3/3, wb, sprintf('Indlæser analysens billeder...'))
        close(wb)
        end
    end
    
    if isvalid(wb)
        close(wb);
    end
end

end

