axes(handles.axDrawROI); 

% Tegn ROI
ROI = impoly;

% Lav maske ud fra ROI
mask = ROI.createMask;

% Find billedets snit (placeringen af slideren)
layerPos = get(handles.SliderLayer, 'Value');
% Antallet af billeder i snittet
mValue = get(handles.SliderROIPicture, 'Max');

% Klargør array til signalintensiteter for hver echotime
y = zeros(1, mValue);
% Klargør struct til pixels signalintensiteter for hver echotime
ech = struct([]);

for i = 1:mValue
    % Find billedet
    image = double(handles.MyData.Layers(layerPos).Images(i).Image);

    % Find den del i image, som ROI'en indkranser
    %image(mask == 0) = 0;
    % Find de intensiteter i billedet, som ROI'en indkranser
    image = image(mask);

    % Normalisér billedet
    pic = image/max(image(:));

    % Tag middelværdi af værdierne i ROI'en
    y(i) = mean(pic(:));
    %idx = pic(mask);
 
    ech(i).Pixels = pic;
%    l(i) = pic(idx);
    
end

y = y';
x = ([handles.MyData.Layers(1).Images.EchoTime])';

f = fit(x,y,'exp1');
figure;
plot(f,x,y)

EchoT2 = struct([]);

for ii = 1:length(ech)
    PixT2 = zeros(1, length(ech(ii).Pixels));
for iii = 1:length(ech(ii).Pixels)
    b = log(ech(ii).Pixels(iii)/f.a)/x(ii);
    PixT2(iii) = -1/b;
end
EchoT2(ii).T2 = PixT2;
end

%T = zeros(1, mValue);
%pMean = 0;

%for ii = 1:length(l)
 %   pMean = pMean + 
  %  
%end


% for i  = 1:mValue
% b(i) = log(p(i)/f.a)/x(i);
% T2p = -1/b(i);
% 
% end



%%

CellNr = strcmp({handles.cellData.Id},id);          % Henter det specefikke Id på cellen der skal analyseres


pos = getPosition(ROI);                             % Henter positionen (x,y,w,h) på den valgte ROI.
border = 25;
cropPos = [pos(1)-border pos(2)-border pos(3)+2*border pos(4)+2*border]; 

if size(handles.imgData.imgFluore.img,3)>1
    gfpZoom = rgb2gray(handles.imgData.imgFluore.img);             % Konvertere det croppede billed fra rgb til gray.                                                   
else
    gfpZoom = handles.imgData.imgFluore.img;
end
gfpZoom = imcrop(gfpZoom,cropPos);        % Cropper det originale billed i forhold til cropPos.
gfpCrop = imcrop(handles.imgData.imgFluore.img,cropPos);                                             
% centerX = pos(1) + pos(3) / 2;
% centerY = pos(2) + pos(4) / 2;

% Create a logical image of the same size as the cropped image
[columnsInImage, rowsInImage] = meshgrid(1:size(gfpZoom,2), 1:size(gfpZoom,1));

centerX = round(size(gfpZoom,1) / 2);
centerY = round(size(gfpZoom,2) / 2);

% Next create the circle in the image. Sinse only the periphery is needed
% two circles is created. One smaller than the other (radius-1 pixel) and
% substracted from eachother.
fluorData = zeros(1,40);
for radius = 1:length(fluorData)
    circlePixels1 = (rowsInImage - centerY).^2 ...
        + (columnsInImage - centerX).^2 <= (radius*2).^2; % Pythagoras circle drawing

    circlePixels2 = (rowsInImage - centerY).^2 ...
        + (columnsInImage - centerX).^2 <= ((radius-1)*2).^2;

    circlePixels = logical(circlePixels1-circlePixels2); %Substracts the two circles and converts the 2D array to logical

    gfpCircle = gfpZoom(circlePixels); %uses the logical periphery as identyfier on the zoom image

    %1. order running averaging filter y(n)=(x(n)+x(n-1))/2 
    if radius == 1
        fluorData(radius) = mean(gfpCircle(:));
    else
        fluorData(radius) = (mean(gfpCircle(:))+fluorData(radius-1))/2;
    end
end