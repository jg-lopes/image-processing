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

% However, applying a full Z normalization (standartization) is ideal,m_idx
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
index_X_train = length(X_train);
X_test = X(index_X_train+1: end, :);
X_train = X(1:index_X_train, :);



% Creating a model using kmeans

% 
N_clusters = 15;
[idx, centroids] = kmeans(X_train, N_clusters);

% However notice that the centroid index in idx is not labeled the same way
% as in the Y_train, therefore we need to have further data treatment
base_truth = cell(1, N_clusters);
for n = 1:length(idx)
    base_truth{idx(n)} = [base_truth{idx(n)} Y_train(n)];
end

for n = 1:N_clusters
    base_truth{n} = mode(base_truth{n});
end

for n = 1:length(idx)
    idx(n) = base_truth{idx(n)};
end

result = idx == Y_train;
fprintf("Kmeans training accuracy: %f\n", sum(result)/length(result));

function idx = findClosestCentroids(X, centroids)

    % findClosestCentroids computes the closest centroid for each point based
    % on the Euclidean distance between the point and the centroid

    % Initialize variables
    K = size(centroids, 1); 
    idx = zeros(size(X,1), 1); % returns index of closest centroid

    for i=1:size(X,1)
        temp = X(i,:);
        [a,idx(i,1)] = min(sum(((bsxfun(@minus,temp,centroids)).^2),2));
%         if i < 5
%             a
%         end
    end

end

idx = findClosestCentroids(X_test, centroids);
old_idx == idx

for n = 1:length(idx)
    idx(n) = base_truth{idx(n)};
end

result = idx == Y_test;
fprintf("Kmeans testing accuracy: %f\n", sum(result)/length(result));


% Creating a model using fitcknn
mdl = fitcknn(X_train, Y_train', 'NumNeighbors', 5, 'Standardize',1);

[label, ~, ~] = predict(mdl, X_train);
result = Y_train == label;
fprintf("Fitcknn Training accuracy: %f\n", sum(result)/length(result));


[label, ~, ~] = predict(mdl, X_test);
result = Y_test == label;
fprintf("Testing accuracy: %f\n", sum(result)/length(result));


end

