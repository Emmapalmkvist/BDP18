function handles = LoadSavedAnalysis(handles)
%LOADSAVEDANALYSIS Indhenter .mat fil med en gemt analyse
%   Tjekker f�rst om der er eksisterende data til GUI'en
%   Derefter bedes brugeren v�lge den �nskede analyse, der skal hentes ind
%   Filen l�ses ind og gemmes i handles, og oplysninger l�gges ud p�
%   brugergr�nsefladen
%
%   INPUT:
%   handles: handle til elementer i gui
%
%   OUTPUT:
%   handles med de indl�ste data i MyData

% Tjekker om der allerede er indhold hentet ind
if isfield(handles, 'MyData')
    layerPos = get(handles.SliderLayer, 'Value');
    if ~isempty(handles.MyData.Layers(layerPos))
        % Prompter brugeren med en sp�rgsm�lboks
        % questdlg(SP�RGSM�L, TITEL, KNAP1, KNAP2, DEFAULTKNAP) 
        choice = questdlg('Der er allerede en analyse i gang der vil blive overskrevet. �nsker du at fors�tte?', ...
            'Overskrivning af analyse', ...
            'Ja','Nej','Ja');
        
        switch choice
            case 'Ja'
                % Forts�ttes der
            case 'Nej'
                return
                % Returneres, s� nedenst�ende kode ikke udf�res
        end
    end
end

% V�lg en matfil
[fileName, pathName] = uigetfile('*.mat');
% Trykkes der ikke annuller:
if fileName ~= 0
    handles = clearGUI(handles);
    % Opretter en waitbar og s�tter den til modal, hvilket s�tter
    % waitbar som forreste vindue.
    wb = waitbar(0, 'Indl�ser analysens billeder...');
    set(wb,'WindowStyle', 'modal' );
    
    % Data indl�ses og gemmes i handles
    savedData = load(fullfile(pathName,fileName));
    % L�gger MyData fra den hentede fil over i handles.MyData
    handles.MyData = savedData.MyData;
    % isvalid tjekker, om wb er valid: ikke er slettet eller er
    % uinitialiseret
    if isvalid(wb)
        waitbar(1/3, wb, sprintf('Indl�ser analysens billeder...'))
    end
    
    % G�r brugergr�nsefladen klar
    set(handles.SliderLayer, 'Value', 1);
    set(handles.SliderROIPicture, 'Value', 1);
    handles = initialiseSliders(handles);
    displayLayers(handles);
    
     % isvalid tjekker, om wb er valid: ikke er slettet eller er
    % uinitialiseret
    if isvalid(wb)
        waitbar(2/3, wb, sprintf('Indl�ser analysens billeder...'))
    end
    
    % Tjekker om der er ROIs, der skal indl�ses
    if isfield(handles.MyData.Layers, 'ROIS')
        % Har vi egentlig lige sat til 1, men hvis nu ombestemmer os en
        % anden gang - s� skal vi ikke �ndre flere steder
        layerPos = get(handles.SliderLayer, 'Value');
        % Placerer gemte ROIs i brugergr�nsefladen
        displayROISonPicture(handles);
        if isvalid(wb)
            waitbar(3/3, wb, sprintf('Indl�ser analysens billeder...'))
            close(wb)
        end
        
        %Finder ud af, hvor mange ROIs der er
        numbROIs = length(handles.MyData.Layers(layerPos).ROIS(:));
        
        if numbROIs ~= 0
            % Opretter en waitbar og s�tter den til modal, hvilket s�tter
            % waitbar som forreste vindue.
            wb = waitbar(0, 'Indl�ser valgte analyse...');
            set(wb,'WindowStyle', 'modal' );
            % Laver variabel til waitbar - skal t�lles op i forl�kke, men der
            % er ogs� en plot-metode senere, som kan tage lidt tid samt mulig
            % indhentning af revideret T2*-v�rdi.
            approxDuration = numbROIs + 1;
            
            % Enable groupbox der viser T2*-v�rdi og ROIs
            set(findall(handles.GroupT2Ana, '-property', 'enable'), 'enable', 'on');
            for i = 1:numbROIs
                oldList = get(handles.lbT2Ana, 'String');
                % strvcat: kobler gammel liste og ny ROI sammen, ved at
                % lave en 'character matrix' med teksten som r�kker
                newList = strvcat(char(oldList), char(handles.MyData.Layers(layerPos).ROIS(i).ROI(1).ROIID));
                % S�tter listen i listboksen
                set(handles.lbT2Ana, 'String', newList);
                if isvalid(wb)
                    waitbar(i/approxDuration, wb, sprintf('Indl�ser valgte analyse...'))
                end
            end
            
            % S�rger for, at den sidste ROI er markeret i listboksen
            set(handles.lbT2Ana, 'Value', numbROIs);
            
            % Fylder T2*-v�rdi og graf ind i brugergr�nsefladen
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
            
            % Tjekker om der ogs� er foretaget en pixelvis fitning
            if isfield(handles.MyData.Layers(layerPos).ROIS(numbROIs).ROI(1).EchoPix, 'T2')
                % Vis min-v�rdi ude i GUI (default er valgt som R^2) samt samt aktiv�r
                % plus-knap og deaktiv�r minus-knap
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
                    waitbar(approxDuration/approxDuration, wb, sprintf('Indl�ser valgte analyse...'))
                end
            end
        end
    else
        if isvalid(wb)
        waitbar(3/3, wb, sprintf('Indl�ser analysens billeder...'))
        close(wb)
        end
    end
    
    if isvalid(wb)
        close(wb);
    end
end

end

