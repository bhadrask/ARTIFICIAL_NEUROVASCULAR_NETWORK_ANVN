function [mlp_train_images,mlp_train_labels,mlp_test_images,mlp_test_labels]= initialize_mlp(mlp_test_size, mlp_train_size, rng_set)
% 	rng(rng_set)

% 	% Load the test and traian data
% 	mlp_labels = loadMNISTLabels('train-labels.idx1-ubyte');
% 	mlp_images = loadMNISTImages('train-images.idx3-ubyte');
    load('train500.mat');
    mlp_labels = strlabels;
    mlp_images = strimages;
    
% 	mlp_test_images = loadMNISTImages('t10k-images.idx3-ubyte');
% 	mlp_test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');
    load('test200.mat');
    mlp_test_labels = strlabels;
    mlp_test_images = strimages;
	mlp_train_tot = size(mlp_images,2);
	

	% Randomly permute the train and test images and labels.
    rng(rng_set);
	mlp_train_perm = randperm(mlp_train_size);
    mlp_test_perm = randperm(mlp_test_size);
    mlp_images = mlp_images(:, mlp_train_perm);
    mlp_labels = mlp_labels(mlp_train_perm);
%     load('test10_trials.mat');
%     mlp_test_images=strimages(:,:,1);
%     mlp_test_labels=strlabels(:,1);
    mlp_test_tot = size(mlp_test_images,2);
    rng(rng_set);
    mlp_test_perm = randperm(mlp_test_tot);
    mlp_test_images = mlp_test_images(:, mlp_test_perm); %images(:, train_perm);
	mlp_test_labels = mlp_test_labels(mlp_test_perm); %labels(train_perm);

	% Take only samples of size train_size and test_size
	mlp_train_images = mlp_images(:, 1:mlp_train_size);
	mlp_train_labels = mlp_labels(1:mlp_train_size);

	mlp_test_images = mlp_test_images(:,1:mlp_test_size);
	mlp_test_labels = mlp_test_labels(1:mlp_test_size);

% 	% Initialize important parameters
% 	mlp_m = size(mlp_images,2);
% 	mlp_n1 = size(mlp_images,1);
% 	mlp_n2 = vas_ln;
% 	mlp_n3 = length(unique([mlp_test_labels; mlp_labels]));
% 	mlp_num_labels = mlp_n3;
% 	mlp_c1 = 5;
% 
% 	% Initialize all the Weights and biases
% 	mlp_W1 = zeros(mlp_n2, mlp_n1, vas_trials);
% 	mlp_b1 =repmat(rand(mlp_n2,1), 1, vas_trials);
% 	mlp_W2 = zeros(mlp_n3, mlp_n2, vas_trials);
% 	mlp_b2 = repmat(rand(mlp_n3,1),1, vas_trials);
% 
% 	% Initialize essential matrices and vectors
% 	mlp_id_mat = eye(mlp_num_labels);

    rng_set = rng;
    
end