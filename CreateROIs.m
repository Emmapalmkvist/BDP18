function [handles, mask] = CreateROIs(handles)
%CREATEROIS giver brugeren mulighed for at markere en eller flere ROIs på et MR-billede.
%   Hver gang der bliver tegnet en ROI på billedet indtaster brugeren et navn på ROI’en,
%   som bliver opdateret i listboxen og som en text på billedet.
%   Derudover bliver hver ROI, der bliver tegnet, gemt i handles med
%   navnet, middelværdien, ekkotiden og positionen.
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   handles med nye værdier i MyData.Layers.ROIS.ROI
%   - ROIID: id (navnet) på ROI'en
%   - Location: placering af ROI'en
%   - MeanValue: middelintensiteterne for ROI'en
%   - EchoPix: oplysninger til senere brug i funktionen 'excludePixels'

axes(handles.axDrawROI);            % Udvælgelse af axes der kan tegnes på.

% Tjekker om handles indeholde MyData eller om MyData er tom og
% notificerer med messagebox og returnerer fra
% funktionen, hvis det er tilfældet.
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Indlæs venligst billeder');
    return;
end

% Tegn ROI
ROI = impoly;

% Hvis ROI'en er blevet tegnet (ESC er ikke trykket), så skal nedenstående
% udføres. Så hvis bruger trykker ESC ved indtegning af ROI skal den ikke
% køre kode
if ~isempty(ROI)
     
    %Bruger navngiver indtegnet ROI. 1 for en linje tekst
    ROInavn = inputdlg('Indtast navn på ROI (vævstype)', 'Navn på ROI', 1, {'Hjerte'});
    
    % Tjekker om man har indtastet et navn på ROI'en
    if ~isempty(ROInavn)
        %Finder ROI position 
        pos = getPosition(ROI);
        
        %Henter værdi af slider til "Billeder i snit"
        layerPos = get(handles.SliderLayer, 'Value');
        %i handletocurrentROIImage ligger det nuværende ROI image
        h_Im = handles.MyData.HandleToCurrentROIImage;
        
        % Lav maske ud fra ROI, vi giver h_Im med, så den ved hvad for et
        % billede den skal beregne masken på, da vi ligger to billeder ovenpå
        % hinanden når der skal farvelægges
        mask = createMask(ROI, h_Im);
        
        % y er middelværdien
        [y, echoPix] = getMeanROI(handles, mask);
        
        %Tjekker om 'ROIS' eksister
        if isfield(handles.MyData.Layers, 'ROIS')
            
            %Tjekker om der ligger noget i ROI i det nuværende valgte lag. 
            %Denne if/else er måske ikke så nødvendig
            if ~isempty(handles.MyData.Layers(layerPos).ROIS)
                %Bruger længden som index. 
                idx = length(handles.MyData.Layers(layerPos).ROIS(:));
            else
                %Hvis ROIS er tom er længden 0 
                idx = 0;
            end
            %gemmer oplysninger om ROI i handles. 
            id = ROInavn;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).ROIID = id;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).Mask = mask;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).Location = pos;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).MeanValue = y;
            handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).EchoPix = echoPix;
            
            set(handles.lbT2Ana, 'Enable', 'on');
            % Sørger for, at den senest tegnede ROI er markeret i
            % listboksen. ikke nødvendig her, kommer senere
            set(handles.lbT2Ana, 'Value', idx+1);
            %For at få flere ROInavne i listboksen, gemmes nuværende tekst
            %i en string. 
            oldList = get(handles.lbT2Ana, 'String');
            %Det nye navn laves ved at sættes det gamle navn sammen med det
            %ny ROIID
            %strvcat laver en matrix af tekst i rækker
            newList = strvcat(char(oldList), char(handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).ROIID));
            %Sætter listboksen med den nye tekst
            set(handles.lbT2Ana, 'String', newList);
            % Sørger for, at den senest tegnede ROI er markeret i listboksen
            set(handles.lbT2Ana, 'Value', idx+1);
            
            
            text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on');
            
            %Clearer eksisterende analyse
            handles = clearAnalysis(handles);
            %Kalder funktionen fitMeanIntensities 
            handles = fitMeanIntensities(handles, idx+1);
        else
            %Denne else bliver benyttet hvis det er den første ROI der
            %indtegnes på billedet
            id = ROInavn;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).ROIID = id;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).Mask = mask;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).Location = pos;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).MeanValue = y;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).EchoPix = echoPix;
            
            % middel af x og y koordinater, så vi får en label for vores
            % ROI, der ligger der hvor vi har tegnet ROI'en
            %Clipping får den til ikke at gå ud over akserne
            text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on')
            
            %Groupbox vises på brugergrænsefladen (OBS, de er allerede
            %visible)
            set(handles.GroupT2Ana, 'Visible', 'on');
            set(handles.GroupChoices, 'Visible', 'on');
            %Første ROIID indsættes i listbox. tuborg-paranterser, fordi vi
            %putter et cellarray i en listbox
            set(handles.lbT2Ana, 'String', {convertCharsToStrings(handles.MyData.Layers(layerPos).ROIS.ROI(1).ROIID)});
            %1 står stadig for 1
            handles = fitMeanIntensities(handles, 1);
        end
    else
        %sletter hvis man har afbrudt navngivning
        delete(ROI);
    end
end

end

