 clc;clear all;close all;
          % number of leaf nodes
% vas.k = 3;             % order at each level
vas.dim = 2 ;          % dimension of the position coordinates
vas.energy_in = 0;     % initialising this to 0 to make energy supply variable inside epochs

vas.energy_mat = [10:10:100,200:100:600];
vas.leaf_mean = 1;

vas.trials = numel(vas.energy_mat);

vas.no_of_attempts = 1;
accuracy_recheck = zeros(vas.trials, vas.no_of_attempts);
colorc = jet(65);
branching =[2,3,4,6,8,32,512];% [16,256,512];%[2,3,4,5,6,15,16,17,50,100,200,255,256];
ACC=0;
for attempt = 1:vas.no_of_attempts
%     figure;
    for k = 1:numel(branching)
        load('F:\Github_team\ANVN_FINAL\MNIST_MLP_training\MNIST_mlp_Train_500_test_200_epochs_20000.mat')
%                  load('D:\github_desktop\Vascular_Tree\task_1\ln_100.mat')
                 opt.W1=W1;
                 opt.W2=W2;
                 opt.b1=b1;
                 opt.b2=b2;
        vas.k = branching(k);
        vas.ln = ln; 
        vas.tree = define_tree(vas.ln, vas.k, vas.dim, vas.energy_in);
        vas.tree = assign_equal_weights(vas.tree);
        vas.b1 = zeros(vas.ln, vas.trials);
        
%         test_images = loadMNISTImages('t10k-images.idx3-ubyte');
%         test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');
        
        test_tot = size(test_images,2);
        
        test_perm = randperm(test_tot);
        test_images = test_images(:, test_perm);
        test_labels = test_labels(test_perm);

%         test_images = test_images(:,1:test_size);
%         test_labels = test_labels(1:test_size);
        
        % Varying the root energy
        for i = 1:vas.trials
            vas.energy_in = vas.energy_mat(i);
            vas.tree.Energy = [vas.energy_in; zeros(vas.tree.Ntot-1,1)];
            vas.tree = energy_flow_equal(vas.tree);
            vas.b1(:,i) = linear_energy_bias(vas.tree.Energy(vas.tree.Ntot-vas.ln+1:end), vas.leaf_mean, opt.b1);
            
            vas.z1 = opt.W1*test_images - repmat(vas.b1(:,i),1,size(test_images,2));
            mlp.c1 = 5;mlp.c2 =0;
            vas.a1 = sigmf(vas.z1, [mlp.c1, mlp.c2]);
            
            vas.z2 = opt.W2*vas.a1 - repmat(opt.b2,1,size(vas.a1,2));
            vas.a2 = sigmf(vas.z2, [1, 0]);
            
            [~, vas.idx] = max(vas.a2);
            vas.accuracy = 100*sum(vas.idx'==test_labels+1)/test_size;
            %             fprintf('Difference (energy: %d, attempt: %d) = %d\n', vas.energy_in, attempt, norm(opt.b1-vas.b1(:,i)));
            accuracy_recheck(i, attempt) = vas.accuracy;
        end
          acc1(k,:)=accuracy_recheck(:,attempt)';
%         figure(1);
%         plot(vas.energy_mat, accuracy_recheck(:,attempt),'color',colorc(20*k,:));ylim([0 100]);hold on;
%         title(['Accuracy check vs Root node energy Optimal training'])
%         ylabel('Accuracy')
%         xlabel('Root node energy');
        
    end
     ACC = ACC + acc1;    
%      legend('k = 16','k = 256','k = 512')
%     %     legend('k = 2','k = 3','k = 4','k = 5','k = 6','k = 15','k = 16','k = 17','k = 50','k = 100','k = 200','k = 255','k = 256')
%     hold off;
end
% ACC=mean(accuracy_recheck,2);
Energy=vas.energy_mat;
ACC=ACC./vas.no_of_attempts;

for k =1:numel(branching)
  figure(1);  plot(vas.energy_mat, ACC(k,:),'color',colorc(5*k,:));ylim([0 100]);
            title(['Accuracy check vs Root node energy Optimal training'])
        ylabel('Accuracy')
        xlabel('Root node energy');
hold on;
efficiency(k,:)=ACC(k,:)./Energy;
efficiency(k,:)=efficiency(k,:)./max(efficiency(k,:));
figure(2);
       yyaxis left
       ylim([0,1])
    plot(Energy,ACC(k,:)/100); xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right
    plot(Energy,efficiency(k,:));ylabel('Normalized Energy Efficiency');hold on;
end
legend('k=2','k=3','k=4','k=6','k=8','k=32','k=512');
% ACC16=ACC(1,:);
% efficiency=ACC16./Energy;
% efficiency=efficiency./max(efficiency);
% figure(2);
%        yyaxis left
%     plot(Energy,ACC16/100); xlabel('Energy at Root Node');
%     ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
%     hold on;
%        yyaxis right
%     plot(Energy,efficiency);ylabel('Normalized Energy Efficiency')
    save('task1_MNIST_data_final_2021.mat','accuracy_recheck','Energy','ACC','efficiency');