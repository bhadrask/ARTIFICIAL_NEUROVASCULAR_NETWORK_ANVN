clear;
close all;
clc;

% Setting the random seed to 1
% rng('default');
%% Defining tree requirements

% rng_saver = rng();

colorc = jet(65);
branching =[2,3,4,6,32,512];%[2,3,4,6,8,32,512];
ACC=0;
for avg=1:1
    for k = 1:numel(branching)
        vas.ln = 512;           % number of leaf nodes
        vas.dim = 2 ;          % dimension of the position coordinates
        vas.energy_in = 0;     % initialising this to 0 to make energy supply variable inside epochs
        vas.eta = 0.1;          % learning rule parameter for vascular side
        
     
        
        str = "k" + '_'+ string(branching(k)) + '.mat';
load('F:\Github_team\ANVN_FINAL\MNIST_MLP_training\MNIST_mlp_Train_500_test_200_epochs_20000.mat')
           mlp.test_size = test_size;
        mlp.train_size = train_size;
% [test.test_images, test.test_labels, mlp.X1, mlp.labels]=load_mnist(mlp.test_size);
          test.test_images=test_images; 
     test.test_labels=test_labels;
     mlp.X1=images;
     mlp.labels=labels;
        %% Vascular side training
        %     rng(rng_saver);
        vas.energy_mat =[10:10:100,200:100:800];
        vas.trials = numel(vas.energy_mat);
        vas.emax = 1;
        vas.epoch = 10000;
        vas.save_every = 1;
        
        tree = define_tree(vas.ln, branching(k), vas.dim, vas.energy_in);
          tree = assign_equal_weights(tree);
                   tree.Weight = tree.equal_weights;
    tree.Weightbefore = tree.Weight;
        fprintf('Training the Vascular weights to accuracy\n')
        [vas,savee1,saveb1,saveacc] = vascular_training(vas, tree, opt.b1, branching(k),avg);
  SAVE_acc(k,:)=saveacc;
        %% Accuracy checking part
        
        accuracy_recheck = zeros(vas.trials, 1);
        vas.b1 = zeros(vas.ln, vas.trials);
        vas.z1 = zeros(vas.ln, numel(test.test_labels), vas.trials);
        vas.a1 = zeros(vas.ln, numel(test.test_labels), vas.trials);
        vas.z2 = zeros(size(W2,1), numel(test.test_labels), vas.trials);
        vas.a2 = zeros(size(W2,1), numel(test.test_labels), vas.trials);
        mlp.c1 =5; mlp.c2=0;
        for i = 1:vas.trials
            vas.energy_in = vas.energy_mat(i);
            vas.tree(i).Energy = [vas.energy_in; zeros(vas.tree(i).Ntot-1,1)];
            vas.tree(i) = energy_flow(vas.tree(i), vas.energy_in);
            
            vas.b1(:,i) = bias_from_weights(vas.tree, vas.emax, i);
            
            vas.z1(:,:,i) = opt.W1*test.test_images - repmat(vas.b1(:,i),1,size(test.test_images,2));
            vas.a1(:,:,i) = sigmf(vas.z1(:,:,i), [mlp.c1, mlp.c2]);
            
            vas.z2(:,:,i) = opt.W2*vas.a1(:,:,i) - repmat(opt.b2,1,size(vas.a1,2));
            vas.a2(:,:,i) = sigmf(vas.z2(:,:,i), [1, 0]);
            
            [~, vas.label] = max(vas.a2(:,:,i));
            vas.accuracy = 100*sum(vas.label' == test.test_labels+1)/mlp.test_size;
            %         fprintf('Difference (energy: %d) = %d\n', vas.energy_in, norm(opt.b1-vas.b1(:,i)));
            accuracy_recheck(i) = vas.accuracy;
             
        end
        
%         plot(vas.energy_mat, accuracy_recheck,'color',colorc(20*k,:));ylim([0 100]);hold on;
%         ylabel('Accuracy');
%         xlabel('Root energy');
%         title('Accuracy vs Root node energy Optimal training');
        acc1(k,:)=accuracy_recheck;
        
%         cd C:\Users\Nagavarshini\Desktop\Newvascular\Vascular_Tree\Vascular_Tree\task_2\trials
cd F:\Github_team\ANVN_FINAL\MNIST_TASK2_Sequential\Task2_data_equal_ini
         str =  'Tune_equal_ini_W' + string(branching(k)) + '_trial_' + string((avg)) +'.mat';
         save(str,'savee1','saveb1','accuracy_recheck','SAVE_acc');
         cd F:\Github_team\ANVN_FINAL\MNIST_TASK2_Sequential
    end
%      legend('k = 16','k = 256','k = 512')
    ACC = ACC + acc1;    
end
ACC=ACC./avg;
figure;
for k =1:numel(branching)
    plot(vas.energy_mat, ACC(k,:),'color',colorc(10*k,:));ylim([0 100]);hold on;
end
ylabel('Accuracy');
xlabel('Root energy');
title('Accuracy vs Root node energy Optimal training');
hold off;
% legend('k = 16','k = 256','k = 512')
Energy=vas.energy_mat;
%    save('Task2_MNIST_data_K_Vary','Energy','ACC');