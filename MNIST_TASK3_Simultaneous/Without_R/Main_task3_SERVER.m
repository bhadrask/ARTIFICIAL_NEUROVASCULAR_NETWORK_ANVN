clc;
clear;
close all;

rng('default');
c = clock;
dir_str = string(c(3)) + '_' + string(c(2)) + '_' + string(c(4)) + '_' +string(c(5));

%% Define tree requirements

vas_ln = 512;%[500:25:700];%[16,64,256, 512,768,900,1024,2048];%,1024,2048];                                % number of leaf nodes
% vas_k = 16;% [64];%[2,15,23,100,256,512];      % k at each level
vas_dim = 2 ;                                % dimension of the position coordinates
% vas_energy_in = 100;                         % here we fix the input energy and then repeat this entiry study for
vas_eta = 0.05;                              % Learning rate for vascular weights
vas_energy_mat = [1,50,100:100:1000];%[1,10:10:100,150:50:600];%200:50:550];                   % [20 10 5];%[100 80 60 40 20 0];
vas_trials = numel(vas_energy_mat);

%% Define MLP requirements

mlp_epoch = 20000;
mlp_eta_max = 0.15;
mlp_eta_min_mat = 0.04;%[0.06, 0.07, 0.08, 0.09, 0.1, 0.12, 0.14, 0.16, 0.18, 0.2];
mlp_batch_size = 100;
mlp_save_every = 1;
mlp_test_size = 200;
mlp_train_size = 500;
% 1+ceil(log(vas_ln_mat)./log(kmat))
% rng_set = rng('default');

[mlp_train_images, mlp_train_labels, mlp_test_images, mlp_test_labels] = initialize_mlp(mlp_test_size, mlp_train_size);
% kmat =[ 16];
kmat=[16,256,512];
% rng(rng_set);
%% Start training both Neural and Vascular
% wallowable = 0.01: 0.05: 0.5;
% parfor i = 1:size(vas_energy_mat,2)
ln_idx=1;
parfor trials= 1:10%:numel(kmat)
    
    fprintf('Branching: %d \n', trials);
    for idx = 1:size(kmat, 2)
        mlp_eta_min = mlp_eta_min_mat;
        % accuracy_recheck = zeros(vas_trials, 1);
        k = kmat(idx);%ceil(nthroot(vas_ln,3));
        % rng(rng_set);
        forvarenegy_eta_SERVER(trials,vas_ln, k, vas_dim, vas_energy_mat, vas_trials, mlp_train_images, mlp_train_labels, mlp_test_images, ...
            mlp_test_labels, mlp_epoch, mlp_save_every, mlp_eta_max, mlp_eta_min, mlp_train_size, mlp_test_size);
    end
end
% end

%%
% % % close all;
% figure();plot(accuracy_test);hold on;
% plot(accuracy_train);hold on;
% plot(100 - accuracy_test);hold on;
% plot(100 - accuracy_train);
% xlabel('Epochs');
% legend('Test Accuracy','Train Accuracy','Test Error','Train Error')
%
% figure();plot(100 - accuracy_test - (100 - accuracy_train));
% title('Difference bet test error and train error');
% xlabel('epochs');ylabel('Difference');
%%
% figure(1);
% hold on;
% leg = 'k = ' + string(vas.k);
% plot(vas.energy_mat, accuracy_train, 'DisplayName',leg);
% hold off;
% tit3 = 'Accuracy check vs Root node energy train';
% legend;
% title(tit3)
% ylabel('Accuracy')
% xlabel('Root node energy');
%
% figure(2);
% hold on;
% plot(vas.energy_mat, accuracy_test, 'DisplayName', leg);
% hold off;
% tit4 = 'Accuracy check vs Root node energy test';
% legend;
% title(tit4)
% ylabel('Accuracy')
% xlabel('Root node energy');