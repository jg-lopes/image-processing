% fonction visu_base(base,arretimage)
% base : nom du r�pertoire contenant la base d'images
% type_image_base : type des images dans la base
% arretimage : si 0, le d�filement est continu, si 1, il faut appuyer sur
% une touche pour obtenir le d�filement image par image.
function visu_base(base,type_image_base,arretimage)
if nargin==0
    base='appr';
    type_image_base='png';
    arretimage=0;
end
close all
liste=dir(fullfile(base,['*.' type_image_base]));
set(figure,'Units','normalized','Position',[5 5 90 85]/100)

for n=1:length(liste)
    nom=liste(n).name;
    Y=double(imread(fullfile(base,nom)))/255;
    fid=fopen(fullfile(base,[nom(1:strfind(nom,'.')-1) '.txt']),'r');
    classe=fscanf(fid,'%d');
    fclose (fid);
    
    % Original Image
    subplot(2,4,1)
    imshow(Y),title(['fichier ' nom ', classe ' int2str(classe)])
    
    % Histogram of image
    subplot(2,4,2)
    imhist(Y)
    %CI=CI/numel(Y);
    %plot(CI)
    %plot(XI,CI), title('Histogram')
    
    % 1.2.3 Obtention d’une image binaire
    subplot(2,4,3)
    BW = imbinarize(Y);
    imshow(BW),title('Black and White Image')
    
    % 1.2.4 Extraction du contour de la forme
    subplot(2,4,4)
    B = bwboundaries(BW);
    imshow(BW), title('BW image with overlay')
    hold on
    for k = 1:length(B)
         boundary = B{k};
         plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
    end
     
     % Comparison of different Cmax values
     subplot(2,4,5)
     z=B{1}(:,1)+1i*B{1}(:,2);
     coeff = dfdir(z, 1);
     z = dfinv(coeff, 1000);
     plot(z), title("Extraction of the countours (cmax = 1)")
     
     subplot(2,4,6)
     z=B{1}(:,1)+1i*B{1}(:,2);
     coeff = dfdir(z, 10);
     z = dfinv(coeff, 1000);
     plot(z), title("Extraction of the countours (cmax = 10)")
     
     subplot(2,4,7)
     z=B{1}(:,1)+1i*B{1}(:,2);
     coeff = dfdir(z, 30);
     z = dfinv(coeff, 1000);
     plot(z), title("Extraction of the countours (cmax = 30)")
     
     subplot(2,4,8)
     z=B{1}(:,1)+1i*B{1}(:,2);
     coeff = dfdir(z, 100);
     z = dfinv(coeff, 1000);
     plot(z), title("Extraction of the countours (cmax = 100)")
     
     drawnow
     
     % 1.2.5 Autres paramètres géométriques and after -> visu_regionprops
end