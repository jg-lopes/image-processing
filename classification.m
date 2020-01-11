function classification(train_folder, test_folder, type_image_base)
if nargin==0
    train_folder ='appr';
    test_folder = 'test';
    type_image_base='png';
    dim_reduction_threshold=80;
end

close all
clc
%set(figure,'Units','normalized','Position',[5 5 90 85]/100)

% Iterating and extracting features
[X_train, Y_train] = folder_parameter_extraction(train_folder, type_image_base);
[X_test, Y_test] = folder_parameter_extraction(test_folder, type_image_base);

% Implementing PCA 

% We could only implement mean normalization, via something like X = X - mean(X);

% However, applying a full Z normalization (standartization) is ideal,
% since it will also normalize the stdev

% However, in order for the normalization to be consistent between the
% training and testing, we need to unify X_train and X_test
X = [X_train; X_test];

X = normalize(X);

% We can now implement PCA in order to study the data
warning('off', 'stats:pca:ColRankDefX');
[coeff, ~, ~, ~, explained] = pca(X);

% We hide the warning since it concerns TSquared, which is never use in
% our code
 
% We used the percentance of total variance explained to set a
% threshold for the dimensionality reduciton
tot_sum = 0;
n = 1;
while tot_sum < dim_reduction_threshold
    tot_sum = tot_sum + explained(n);
    n = n + 1;
end

% After analysis of latent, we can chose to apply a dimentionality
% reduction to only 4 dimenisions without significant losses in information
X = X * coeff(:, 1:n);

% Reconstructing the separate X_train and X_test using the size of the
% original matrices
X_test = X(length(X_train)+1: end, :);
X_train = X(1:length(X_train), :);



% Creating a model using KNN
mdl = fitcknn(X_train, Y_train', 'NumNeighbors', 5, 'Standardize',1);

[label, ~, ~] = predict(mdl, X_train);
result = Y_train == label;
fprintf("Training accuracy: %f\n", sum(result)/length(result));


[label, ~, ~] = predict(mdl, X_test);
result = Y_test == label;
fprintf("Testing accuracy: %f\n", sum(result)/length(result));


end

