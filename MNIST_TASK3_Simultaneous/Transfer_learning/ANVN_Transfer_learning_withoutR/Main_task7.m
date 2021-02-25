clc;clear all;close all;
rng('default');

%% Define tree requirements
vas.ln = 512;          % number of leaf nodes
vas.k = 16;            % k at each level
vas.dim = 2 ;         % dimension of the position coordinates
vas.energy_in = 300;  % here we fix the input energy and then repeat this entiry study for
vas.eta = 0.05;       % Learning rate for vascular weights

%% Define MLP requirements

mlp.test_size = 200;
mlp.train_size = 500;
mlp.epoch = 20000;
mlp.eta = 0.5;

rng('default')

%% Training DATASET
labels = loadMNISTLabels('train-labels.idx1-ubyte');
images = loadMNISTImages('train-images.idx3-ubyte');

set1n=1;
set2n=1;

for n=1:size(labels,1)
    if labels(n,1)>=5
        mlp.images2(:,set2n) = images(:,n);
        mlp.labels2(set2n,1) = labels(n,1)-5;
        set2n = set2n + 1;
    else
        mlp.images1(:,set1n) = images(:,n);
        mlp.labels1(set1n,1) = labels(n,1);
        set1n = set1n + 1;
    end
end
% Testing Dataset
test_images = loadMNISTImages('t10k-images.idx3-ubyte');
test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');
set1n=1;
set2n=1;
for n=1:size(test_labels,1)
    if test_labels(n,1)>=5
        mlp.test_images2(:,set2n) = test_images(:,n);
        mlp.test_labels2(set2n,1) = test_labels(n,1)-5;
        set2n = set2n + 1;
    else
        mlp.test_images1(:,set1n) = test_images(:,n);
        mlp.test_labels1(set1n,1) = test_labels(n,1);
        set1n = set1n + 1;
    end
end

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
mlp.c1 = 5;

vas.energy_mat = vas.energy_in ;%[1,100:50:800]; % [20 10 5];%[100 80 60 40 20 0];
vas.trials = numel(vas.energy_mat);

mlp.W1 = zeros(mlp.n2, mlp.n1, vas.trials);
mlp.b1 =repmat(rand(mlp.n2,1), 1, vas.trials);
mlp.W2 = zeros(mlp.n3, mlp.n2, vas.trials);
mlp.b2 = repmat(rand(mlp.n3,1),1, vas.trials);

mlp.id_mat = eye(mlp.num_labels);
mlp_eta_max = 0.15;
mlp_eta_min = 0.04;%[0.06, 0.07, 0.08, 0.09, 0.1, 0.12, 0.14, 0.16, 0.18, 0.2];

save_every = 50;

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
            fprintf('Epoch: %d \n', i);
        end
        
        % Vascular forward energy flow ---------1
        vas.tree(j) = energy_flow(vas.tree(j), vas.energy_in);

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
        delta3 = mlp.id_mat(:, mlp.labels1+1) - a2;
        delta2 = (delta3.*a2.*(1-a2));
        delta1 = (mlp.W2(:,:,j)'*delta2).*(mlp.c1.*a1.*(1-a1));
        
        dW2 = (delta2*a1')/mlp.m;
        dW1 = (delta1*X1')/mlp.m;
        db2 = -sum(delta2, 2)/mlp.m;
        db1 = -sum(delta1, 2)/mlp.m;
        
        % get the eta based on exp decay
                    factor = 8000;
            eta = get_exp_eta(i, mlp.epoch, mlp_eta_max, mlp_eta_min, factor);
        mlp.W2(:,:,j) = mlp.W2(:,:,j) + eta*dW2;
        mlp.W1(:,:,j) = mlp.W1(:,:,j) + eta*dW1;
        mlp.b2(:,j) = mlp.b2(:,j) + eta*db2;
        
       % NEW CHANGE
       % mlp.b1(:,j) = mlp.b1(:,j) - eta*db1;
        del_energy = calculate_delta_energy(vas.tree(j), db1);
         str_dele(1,i) = sqrt(sum(del_energy.^2));
        % Normalization of weights
        mlp = weightnorm(mlp);
                 
        % Update Vascular Weights --------------6
        % CHANGED THE INPUT VECTORS AS ENTIRE LEAVES
         vas.eta = get_exp_vas_eta(i, mlp.epoch, 0.02, 0.001);
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
save('newdata1train_20kepoch.mat','mlp','vas','str_dele');
%% Start training both Neural and Vascular with Data2
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
    vas.tree(j) = tree;
    vas.tree(j).Energy = [vas.energy_in; zeros(vas.tree(j).Ntot-1,1)];
    vas.tree(j) = energy_flow(vas.tree(j), vas.energy_in);
    
    fprintf('Energy: %d \n', j);

    for i = 1:mlp.epoch
        
        if rem(i, save_every) == 0
            fprintf('Epoch: %d \n', i);
        end
        
        % Vascular forward energy flow ---------1
        vas.tree(j) = energy_flow(vas.tree(j), vas.energy_in);

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
        
        % get the eta based on exp decay
        factor = 8000;
            eta = get_exp_eta(i, mlp.epoch, mlp_eta_max, mlp_eta_min, factor);
        
        mlp.W2(:,:,j) = mlp.W2(:,:,j) + eta*dW2;
        mlp.W1(:,:,j) = mlp.W1(:,:,j) + eta*dW1;
        mlp.b2(:,j) = mlp.b2(:,j) + eta*db2;
        
       % NEW CHANGE
       % mlp.b1(:,j) = mlp.b1(:,j) - eta*db1;
        del_energy = calculate_delta_energy(vas.tree(j), db1);
        str_dele(1,i) = sqrt(sum(del_energy.^2));
        % Normalization of weights
        mlp = weightnorm(mlp);
                 
        % Update Vascular Weights --------------6
        % CHANGED THE INPUT VECTORS AS ENTIRE LEAVES
         vas.eta = get_exp_vas_eta(i, mlp.epoch, 0.02, 0.001);
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
save('newdata2train_20kepoch.mat','mlp','vas','str_dele');
