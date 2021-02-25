clc;clear all;close all;
rng('default');
tic
%% Define tree requirements
vas.ln = 512;          % number of leaf nodes
vas.k = 3;            % k at each level
vas.dim = 2 ;         % dimension of the position coordinates
vas.energy_in = 500;  % here we fix the input energy and then repeat this entiry study for
% vas.eta = 0.05;       % Learning rate for vascular weights

%% Define MLP requirements
mlp.epoch = 20000;
% mlp.eta = 0.5;
% mlp.test_size = 500;
% mlp.train_size = 2000;
mlp_eta_max = 0.08;
mlp_eta_min = 0.02;
factor = 5000;

rng('default')

%% Training DATASET

load('Mnist_Equal_TRAIN_500.mat');
mlp.labels1 = strlabels;
mlp.images1 = strimages;
mlp.train_size = size(strimages,2);

load('Mnist_Equal_TEST_200.mat');
mlp.test_images1 = strimages;
mlp.test_labels1 = strlabels;

mlp.test_size=size(strimages,2);


%% Training on Data 1
mlp.train_tot = size(mlp.images1,2);
mlp.test_tot = size(mlp.test_images1,2);

% Randomly permute the train and test images and labels.
mlp.train_perm = randperm(mlp.train_tot);
mlp.images1 = mlp.images1(:, mlp.train_perm);
mlp.labels1 = mlp.labels1(mlp.train_perm);

mlp.test_perm = randperm(mlp.test_tot);
mlp.test_images1 = mlp.test_images1(:, mlp.test_perm); %images(:, train_perm);
mlp.test_labels1 = mlp.test_labels1(mlp.test_perm); %labels(train_perm);

% Take only samples of size train_size and test_size
mlp.images1 = mlp.images1(:, 1:mlp.train_size);
mlp.labels1 = mlp.labels1(1:mlp.train_size);

mlp.test_images1 = mlp.test_images1(:,1:mlp.test_size);
mlp.test_labels1 = mlp.test_labels1(1:mlp.test_size);

% Initialize important parameters
mlp.m = size(mlp.images1,2);
mlp.n1 = size(mlp.images1,1);
mlp.n2 = vas.ln;
mlp.n3 = length(unique([mlp.test_labels1; mlp.labels1]));
mlp.num_labels = mlp.n3;
mlp.c1 = 15;

vas.energy_mat = vas.energy_in;%0:100:100; % [20 10 5];%[100 80 60 40 20 0];
vas.trials = numel(vas.energy_mat);

mlp.W1 = zeros(mlp.n2, mlp.n1, vas.trials);
mlp.b1 =repmat(rand(mlp.n2,1), 1, vas.trials);
mlp.W2 = zeros(mlp.n3, mlp.n2, vas.trials);
mlp.b2 = repmat(rand(mlp.n3,1),1, vas.trials);

mlp.id_mat = eye(mlp.num_labels);

save_every = 1;

mlp.train_success = zeros(vas.trials, mlp.epoch/save_every);
mlp.test_success = zeros(vas.trials, mlp.epoch/save_every);

%% Start training both Neural and Vascular with Data1
accuracy_recheck = zeros(vas.trials, 1);
tree = define_tree(vas.ln, vas.k, vas.dim, vas.energy_in);
X1 = mlp.images1;

for j = 1:vas.trials
    % Energy
    vas.energy_in = vas.energy_mat(j);
    vas.tree(j) = tree;
    vas.tree(j).Energy = [vas.energy_in; zeros(vas.tree(j).Ntot-1,1)];
    vas.tree(j) = energy_flow(vas.tree(j), vas.energy_in);
    
    fprintf('Energy: %d \n', j);
    
    for i = 1:mlp.epoch
        
        if rem(i, save_every) == 0
            fprintf('SET 1 Epoch: %d \n', i);
        end
        
        % Vascular forward energy flow ---------1
        vas.tree(j) = energy_flow(vas.tree(j), vas.energy_in);
        
% vas.percapita(i)=sum(vas.tree.Energy(vas.tree.leaf_idx))/numel(vas.tree.Energy(vas.tree.leaf_idx));

        
        % NEW CHANGE
        mlp.b1(:,j) = calculate_bias(vas.tree(j));
        
        % Neural Forward Activity ------------3
        z1 = mlp.W1(:,:,j)*X1 - repmat(mlp.b1(:,j),1,mlp.train_size);
        a1 = sigmf(z1, [mlp.c1, 0]);
        
        z2 = mlp.W2(:,:,j)*a1 - repmat(mlp.b2(:,j),1,mlp.train_size);
        a2 = sigmf(z2, [1, 0]);
        
        % Update weight and bias of Neural -----------4
        delta3 = mlp.id_mat(:, mlp.labels1+1) - a2;
        delta2 = (delta3.*a2.*(1-a2));
        delta1 = (mlp.W2(:,:,j)'*delta2).*(mlp.c1.*a1.*(1-a1));
        
        dW2 = (delta2*a1')/mlp.m;
        dW1 = (delta1*X1')/mlp.m;
        db2 = -sum(delta2, 2)/mlp.m;
        db1 = -sum(delta1, 2)/mlp.m;
        
        % get the eta based on exp decay
        eta = get_exp_eta(i, mlp_eta_max, mlp_eta_min, factor);
        
        mlp.W2(:,:,j) = mlp.W2(:,:,j) + eta*dW2;
        mlp.W1(:,:,j) = mlp.W1(:,:,j) + eta*dW1;
        mlp.b2(:,j) = mlp.b2(:,j) + eta*db2;
        str_delW(1,i) = sqrt(sum(sum(dW1.^2))/numel(dW1));
        % NEW CHANGE
        % mlp.b1(:,j) = mlp.b1(:,j) - eta*db1;
        del_energy = calculate_delta_energy(vas.tree(j), db1);
        str_dele(1,i) = sqrt(sum(del_energy.^2)/numel(del_energy));
        % Normalization of weights
        mlp = weightnorm(mlp);
        
        % Update Vascular Weights --------------6
        % CHANGED THE INPUT VECTORS AS ENTIRE LEAVES
       vas.eta = get_exp_vas_eta(i, 0.01, 0.001,10000);
        vas.tree(j) = vascular_weight_update(vas.tree(j), vas.tree(j).leaf_idx, del_energy, vas.eta);
        
        if rem(i,save_every)==0
            [~, idx] = max(a2);
            mlp.train_success(j, i/save_every) = sum(idx' == mlp.labels1+1);
            
            % Check testing
            t1 = mlp.test_images1;
            t2 = sigmf(mlp.W1(:,:,j)*t1 - repmat(mlp.b1(:,j),1, mlp.test_size), [mlp.c1, 0]);
            t3 = sigmf(mlp.W2(:,:,j)*t2 - repmat(mlp.b2(:,j),1, mlp.test_size), [1, 0]);
            [~, tidx] = max(t3);
            mlp.test_success(j, i/save_every) = sum(tidx' == mlp.test_labels1 + 1);
        end
    end
end
accuracy_test = (mlp.test_success(:,end)/(size(mlp.test_images1,2)))*100;
accuracy_train = (mlp.train_success(:,end)/(size(mlp.images1,2)))*100;
save('T2_Feb2021_E500_DATA1_MNIST_EMNIST.mat','mlp','vas','accuracy_test','accuracy_train','str_dele','str_delW');
% save('EMNIST_tune.mat','mlp','vas','accuracy_test','accuracy_train','str_dele','str_delW');

W1=sum(vas.tree.Weight,2);
%% Start training both Neural and Vascular with Data2


load('EMnist_Equal_TRAIN_500.mat');
mlp.labels2 = strlabels;
mlp.images2 = strimages;
mlp.train_size=size(strimages,2);
load('EMnist_Equal_TEST_200.mat');
mlp.test_images2 =strimages;
mlp.test_labels2 = strlabels;

mlp.train_tot = size(mlp.images2,2);
mlp.test_tot = size(mlp.test_images2,2);

% Randomly permute the train and test images and labels.
mlp.train_perm = randperm(mlp.train_tot);
mlp.images2 = mlp.images2(:, mlp.train_perm);
mlp.labels2 = mlp.labels2(mlp.train_perm);

mlp.test_perm = randperm(mlp.test_tot);
mlp.test_images2 = mlp.test_images2(:, mlp.test_perm); %images(:, train_perm);
mlp.test_labels2 = mlp.test_labels2(mlp.test_perm); %labels(train_perm);

% Take only samples of size train_size and test_size
mlp.images2 = mlp.images2(:, 1:mlp.train_size);
mlp.labels2 = mlp.labels2(1:mlp.train_size);

mlp.test_images2 = mlp.test_images2(:,1:mlp.test_size);
mlp.test_labels2 = mlp.test_labels2(1:mlp.test_size);

%% Training on Data 2
accuracy_recheck = zeros(vas.trials, 1);
% tree = define_tree(vas.ln, vas.k, vas.dim, vas.energy_in);
X1 = mlp.images2;

for j = 1:vas.trials
    % Energy
    vas.energy_in = vas.energy_mat(j);
%     vas.tree(j) = tree;
    vas.tree(j).Energy = [vas.energy_in; zeros(vas.tree(j).Ntot-1,1)];
    vas.tree(j) = energy_flow(vas.tree(j), vas.energy_in);
    
    fprintf('Energy: %d \n', j);
    
    for i = 1:mlp.epoch
        
        if rem(i, save_every) == 0
            fprintf('SET 2 Epoch: %d \n', i);
        end
        
        % Vascular forward energy flow ---------1
        vas.tree(j) = energy_flow(vas.tree(j), vas.energy_in);
%         vas.percapita(i)=sum(vas.tree.Energy(vas.tree.leaf_idx))/numel(vas.tree.Energy(vas.tree.leaf_idx));
  W2=sum(vas.tree.Weight,2);
        diffW=abs(W1-W2);
        for lv=1:max(vas.tree.Level)
            Wdifflevel=diffW(vas.tree.Level==lv);
            VRMSE(i,lv)=sqrt(sum(Wdifflevel).^2);
            clear Wdifflevel
            
        end

        
        % NEW CHANGE
        mlp.b1(:,j) = calculate_bias(vas.tree(j));
        
        % Neural Threshold -------------2
        % b1=1-(vas.tree(j).Energy(vas.tree(j).leaf_idx));
        % mlp.b1(:,j)=b1;
        
        % Neural Forward Activity ------------3
        z1 = mlp.W1(:,:,j)*X1 - repmat(mlp.b1(:,j),1,mlp.train_size);
        a1 = sigmf(z1, [mlp.c1, 0]);
        
        z2 = mlp.W2(:,:,j)*a1 - repmat(mlp.b2(:,j),1,mlp.train_size);
        a2 = sigmf(z2, [1, 0]);
        
        % Update weight and bias of Neural -----------4
        delta3 = mlp.id_mat(:, mlp.labels2+1) - a2;
        delta2 = (delta3.*a2.*(1-a2));
        delta1 = (mlp.W2(:,:,j)'*delta2).*(mlp.c1.*a1.*(1-a1));
        
        dW2 = (delta2*a1')/mlp.m;
        dW1 = (delta1*X1')/mlp.m;
        db2 = -sum(delta2, 2)/mlp.m;
        db1 = -sum(delta1, 2)/mlp.m;
        str_delW(1,i) = sqrt(sum(sum(dW1.^2))/numel(dW1));
        % get the eta based on exp decay
        eta = get_exp_eta(i,0.04,0.01, factor);
        
        mlp.W2(:,:,j) = mlp.W2(:,:,j) + eta*dW2;
        mlp.W1(:,:,j) = mlp.W1(:,:,j) + eta*dW1;
        mlp.b2(:,j) = mlp.b2(:,j) + eta*db2;
        
        % NEW CHANGE
        del_energy = calculate_delta_energy(vas.tree(j), db1);
        str_dele(1,i) = sqrt(sum(del_energy.^2)/numel(del_energy));
        % Normalization of weights
        mlp = weightnorm(mlp);
        
        % Update Vascular Weights --------------6
        % CHANGED THE INPUT VECTORS AS ENTIRE LEAVES
        
       vas.eta = get_exp_vas_eta(i, 0.001, 0.0005,10000);
        vas.tree(j) = vascular_weight_update(vas.tree(j), vas.tree(j).leaf_idx, del_energy, vas.eta);
      
        if rem(i,save_every)==0
            [~, idx] = max(a2);
            mlp.train_success(j, i/save_every) = sum(idx' == mlp.labels2+1);
            
            % Check testing
            t1 = mlp.test_images2;
            t2 = sigmf(mlp.W1(:,:,j)*t1 - repmat(mlp.b1(:,j),1, mlp.test_size), [mlp.c1, 0]);
            t3 = sigmf(mlp.W2(:,:,j)*t2 - repmat(mlp.b2(:,j),1, mlp.test_size), [1, 0]);
            [~, tidx] = max(t3);
            mlp.test_success(j, i/save_every) = sum(tidx' == mlp.test_labels2 + 1);
        end
    end
end

accuracy_test = (mlp.test_success(:,end)/(size(mlp.test_images2,2)))*100;
accuracy_train = (mlp.train_success(:,end)/(size(mlp.images2,2)))*100;
 toc
save('T2_Feb2021_TL7_E500_DATA2_MNIST_EMNIST.mat','mlp','vas','accuracy_test','accuracy_train','str_dele','str_delW','VRMSE');
