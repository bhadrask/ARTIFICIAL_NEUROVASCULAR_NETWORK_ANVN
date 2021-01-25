clear;
close all;
clc;
branching =[16,64,128,256,512];
ACC=0;
for avg=1:9
    for k = 1:numel(branching)
%         load('F:\Github_team\ANVN_FINAL\MNIST_MLP_training\MNIST_mlp_Train_500_test_200_epochs_20000.mat')
%         mlp.test_size = test_size;
%         mlp.train_size = train_size;
%         test.test_images=test_images;
%         test.test_labels=test_labels;
%         mlp.X1=images;
%         mlp.labels=labels;
        cd F:\Github_team\ANVN_FINAL\MNIST_TASK2_Sequential\Task2_data_equal_ini
        str =  'equal_ini_W' + string(branching(k)) + '_trial_' + string((avg)) +'.mat';
        load(str);
        cd F:\Github_team\ANVN_FINAL\MNIST_TASK2_Sequential
        E_vec=sum(savee1,2);
        acc1(k,:)=accuracy_recheck;
    end
    %
    ACC = ACC + acc1;
end
ACC=ACC./avg;
legendTitle = cell(1,numel(branching));
figure(1);
for k =1:numel(branching)
    plot(E_vec, ACC(k,:));ylim([0 100]);hold on;
    legendTitle{1,k} = strcat('k= ',num2str(branching(k)));
end
legend(legendTitle);
ylabel('Accuracy');
xlabel('Root energy');
title('Accuracy vs Root node energy Optimal training');