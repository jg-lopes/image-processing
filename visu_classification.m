% fonction visu_base(base,arretimage)
% base : nom du r�pertoire contenant la base d'images
% type_image_base : type des images dans la base
% arretimage : si 0, le d�filement est continu, si 1, il faut appuyer sur
% une touche pour obtenir le d�filement image par image.
function visu_classification(base,type_image_base,arretimage)
if nargin==0
    base='appr';
    type_image_base='png';
    arretimage=0;
end

close all
liste=dir(fullfile(base,['*.' type_image_base]));
set(figure,'Units','normalized','Position',[5 5 90 85]/100)

% Iterating and extracting features
X = [];
Y = [];
for n=1:length(liste)
    nom=liste(n).name;
    image=double(imread(fullfile(base,nom)))/255;
    fid=fopen(fullfile(base,[nom(1:strfind(nom,'.')-1) '.txt']),'r');
    classe=fscanf(fid,'%d');
    fclose (fid);

    parameters = parameter_extraction(image);
    
    X = [X; parameters];
    Y = [Y; classe];
end

%X = X - mean(X);
%X = pca(X);
%size(X)
%[coeff,score] = pca(X);
%X = coeff(:, 1:50) * score(:, 1:50)')';
%X = score(:, 1:50) * coeff(:, 1:50)';
%X = score(:, 1:10);
%size(X)

% =========================================================================

% Train test data splitting
%data = [X Y];
% Cross varidation (train: 70%, test: 30%)
%cv = cvpartition(size(data,1),'HoldOut',0.3);
%idx = cv.test;
% Separate to training and test data
%dataTrain = data(~idx,:);
%xTrain = dataTrain(:, 1:end-1);
%yTrain = dataTrain(:, end);

%dataTest  = data(idx,:);
%xTest = dataTest(:, 1:end-1);
%yTest = dataTest(:, end);

cv = cvpartition(Y, 'holdout', .5);
Xtrain = X(cv.training,:);
Ytrain = Y(cv.training,1);

Xtest = X(cv.test,:);
Ytest = Y(cv.test,1);
% =========================================================================

% Creating a model using KNN
mdl = fitcknn(Xtrain, Ytrain', 'NumNeighbors', 10, 'Standardize',1);

[label, score, cost] = predict(mdl, Xtrain);
Ytrain
result = Ytrain == label;
sum(result)/length(result)
fprintf("Training accuracy: %f\n", sum(result)/length(result));


[label, score, cost] = predict(mdl, Xtest);
result = Ytest == label;
fprintf("Testing accuracy: %f\n", sum(result)/length(result));


[label, score, cost] = predict(mdl, X);
for n=1:length(liste)
    nom=liste(n).name;
    image=double(imread(fullfile(base,nom)))/255;
    fid=fopen(fullfile(base,[nom(1:strfind(nom,'.')-1) '.txt']),'r');
    classe=fscanf(fid,'%d');
    fclose (fid);
    subplot(1,2,1)
    imshow(image),title(['fichier ' nom ', classe ' int2str(classe)])
    
    subplot(1,2,2)    
    BW = imbinarize(image);
    imshow(BW),title(['fichier ' nom ', classe ' int2str(label(n))])
    
    pause(1)
    
end