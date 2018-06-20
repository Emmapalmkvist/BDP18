function [handles, mask] = CreateROIs(handles)
%CREATEROIS giver brugeren mulighed for at markere en eller flere ROIs p� et MR-billede.
%   Hver gang der bliver tegnet en ROI p� billedet indtaster brugeren et navn p� ROI�en,
%   som bliver opdateret i listboxen og som en text p� billedet.
%   Derudover bliver hver ROI, der bliver tegnet, gemt i handles med
%   navnet, middelv�rdien, ekkotiden og positionen.
%
%   INPUT:
%   handles til elementer i gui
%
%   OUTPUT:
%   handles med nye v�rdier i MyData.Layers.ROIS.ROI
%   - ROIID: id (navnet) p� ROI'en
%   - Location: placering af ROI'en
%   - MeanValue: middelintensiteterne for ROI'en
%   - EchoPix: oplysninger til senere brug i funktionen 'excludePixels'

axes(handles.axDrawROI);            % Udv�lgelse af axes der kan tegnes p�.

% Tjekker om handles indeholde MyData eller om MyData er tom og
% notificerer med messagebox og returnerer fra
% funktionen, hvis det er tilf�ldet.
if ~isfield(handles, 'MyData') || isempty(handles.MyData)
    msgbox('Indl�s venligst billeder');
    return;
end

% Tegn ROI
ROI = impoly;

% Hvis ROI'en er blevet tegnet (ESC er ikke trykket), s� skal nedenst�ende
% udf�res. S� hvis bruger trykker ESC ved indtegning af ROI skal den ikke
% k�re kode
if ~isempty(ROI)
     
    %Bruger navngiver indtegnet ROI. 1 for en linje tekst
    ROInavn = inputdlg('Indtast navn p� ROI (v�vstype)', 'Navn p� ROI', 1, {'Hjerte'});
    
    % Tjekker om man har indtastet et navn p� ROI'en
    if ~isempty(ROInavn)
        %Finder ROI position 
        pos = getPosition(ROI);
        
        %Henter v�rdi af slider til "Billeder i snit"
        layerPos = get(handles.SliderLayer, 'Value');
        %i handletocurrentROIImage ligger det nuv�rende ROI image
        h_Im = handles.MyData.HandleToCurrentROIImage;
        
        % Lav maske ud fra ROI, vi giver h_Im med, s� den ved hvad for et
        % billede den skal beregne masken p�, da vi ligger to billeder ovenp�
        % hinanden n�r der skal farvel�gges
        mask = createMask(ROI, h_Im);
        
        % y er middelv�rdien
        [y, echoPix] = getMeanROI(handles, mask);
        
        %Tjekker om 'ROIS' eksister
        if isfield(handles.MyData.Layers, 'ROIS')
            
            %Tjekker om der ligger noget i ROI i det nuv�rende valgte lag. 
            %Denne if/else er m�ske ikke s� n�dvendig
            if ~isempty(handles.MyData.Layers(layerPos).ROIS)
                %Bruger l�ngden som index. 
                idx = length(handles.MyData.Layers(layerPos).ROIS(:));
            else
                %Hvis ROIS er tom er l�ngden 0 
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
            % S�rger for, at den senest tegnede ROI er markeret i
            % listboksen. ikke n�dvendig her, kommer senere
            set(handles.lbT2Ana, 'Value', idx+1);
            %For at f� flere ROInavne i listboksen, gemmes nuv�rende tekst
            %i en string. 
            oldList = get(handles.lbT2Ana, 'String');
            %Det nye navn laves ved at s�ttes det gamle navn sammen med det
            %ny ROIID
            %strvcat laver en matrix af tekst i r�kker
            newList = strvcat(char(oldList), char(handles.MyData.Layers(layerPos).ROIS(idx+1).ROI(1).ROIID));
            %S�tter listboksen med den nye tekst
            set(handles.lbT2Ana, 'String', newList);
            % S�rger for, at den senest tegnede ROI er markeret i listboksen
            set(handles.lbT2Ana, 'Value', idx+1);
            
            
            text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on');
            
            %Clearer eksisterende analyse
            handles = clearAnalysis(handles);
            %Kalder funktionen fitMeanIntensities 
            handles = fitMeanIntensities(handles, idx+1);
        else
            %Denne else bliver benyttet hvis det er den f�rste ROI der
            %indtegnes p� billedet
            id = ROInavn;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).ROIID = id;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).Mask = mask;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).Location = pos;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).MeanValue = y;
            handles.MyData.Layers(layerPos).ROIS.ROI(1).EchoPix = echoPix;
            
            % middel af x og y koordinater, s� vi f�r en label for vores
            % ROI, der ligger der hvor vi har tegnet ROI'en
            %Clipping f�r den til ikke at g� ud over akserne
            text(mean(pos(:,1)), mean(pos(:,2)), id, 'Color', 'y', 'Clipping', 'on')
            
            %Groupbox vises p� brugergr�nsefladen (OBS, de er allerede
            %visible)
            set(handles.GroupT2Ana, 'Visible', 'on');
            set(handles.GroupChoices, 'Visible', 'on');
            %F�rste ROIID inds�ttes i listbox. tuborg-paranterser, fordi vi
            %putter et cellarray i en listbox
            set(handles.lbT2Ana, 'String', {convertCharsToStrings(handles.MyData.Layers(layerPos).ROIS.ROI(1).ROIID)});
            %1 st�r stadig for 1
            handles = fitMeanIntensities(handles, 1);
        end
    else
        %sletter hvis man har afbrudt navngivning
        delete(ROI);
    end
end

end

