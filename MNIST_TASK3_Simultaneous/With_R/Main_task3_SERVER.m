clc;
clear;
close all;

rng('default');
c = clock;
dir_str = string(c(3)) + '_' + string(c(2)) + '_' + string(c(4)) + '_' +string(c(5));

%% Define tree requirements

vas_ln_mat = [10:20:100,150:50:500];%[20,24,28,36,40,44,48,52,56];%[16,32,64,72,80,96,100:25:500]; %[64,125:50:800];
vas_dim = 2 ;                                % dimension of the position coordinates
vas_eta = 0.05;                              % Learning rate for vascular weights
vas_energy_mat = 5000;                       % Set input energy
% vas_trials = numel(vas_energy_mat);

%% Define MLP requirements

mlp_epoch = 2000;
mlp_eta_max = 0.15;
mlp_eta_min = 0.04;
mlp_batch_size = 100;
mlp_save_every = 1;
mlp_test_size = 200;
mlp_train_size = 500;
% 1+ceil(log(vas_ln_mat)./log(kmat))
%for trial =1%:5
vas_trials = 1;
trial = 1;
rng_set = rng(trial);
[mlp_train_images, mlp_train_labels, mlp_test_images, mlp_test_labels] = initialize_mlp(mlp_test_size, mlp_train_size,rng_set);

% Start training both Neural and Vascular
wallowable_fraction = 0.2:0.2:1;
parfor i = 1:numel(wallowable_fraction)
    kmat = [3,4,4,8*ones(1,10)]; %[4, 8*ones(1,8), 16*ones(1,6)];

    for ln_idx =1:size(vas_ln_mat,2)
        vas_ln = vas_ln_mat(ln_idx);
        wallowable = (wallowable_fraction.*vas_ln)/5000;
        % for idx = 1:size(mlp_eta_min_mat, 2)
        k = kmat(ln_idx);
        forvarenegy_eta_SERVER(vas_ln, k, vas_dim, vas_energy_mat, vas_trials, mlp_train_images, mlp_train_labels, mlp_test_images, ...
           mlp_test_labels, mlp_epoch, mlp_save_every, mlp_eta_max, mlp_eta_min, mlp_train_size, mlp_test_size, wallowable(i),rng_set,trial);
        % end
    end
end
%end
