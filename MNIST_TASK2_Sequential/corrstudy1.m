clear ; close all; clc;
kk=32;%[2,3,4,6,32,512];%3;%[16,256,512];
legendTitle = cell(1,numel(kk));
load('D:\github_desktop\ANVN_FINAL\MNIST_MLP_training\MNIST_mlp_Train_500_test_200_epochs_20000.mat')
for i=3:3
    for br=1:numel(kk)
    str = 'D:\github_desktop\ANVN_FINAL\FINAL_DATA_SET_and_plotting_codes\DATASET\TASK2_sequential\opti_k_' + string(kk(br)) + '_trial_'+  string(i)+ '.mat';
    load(str)
    Emlp=1-b1;
    Eavail=1-saveb1;
    rooten=sum(savee1,2);
    loc=find(abs(rooten-500)<1e-3);%numel(rooten);%
    deficiency=mean(abs(Emlp-Eavail'));
     efficiency=(accuracy_recheck-accuracy_recheck(2))./rooten;
    yyaxis left

    figure(1);plot(rooten(2:loc),deficiency(2:loc),'LineWidth',3);
    xlabel('Root energy'); ylabel('Energy Deficit'); ylim([0,1]);hold on;
     plot(rooten(2:loc),efficiency(2:loc),'LineWidth',3);
     hold on ;
    yyaxis right
    plot(rooten(2:loc),accuracy_recheck(2:loc) ,'LineWidth',3); 
    xlabel('Root energy'); ylabel('Test Accuracy'); ylim([0,100]);title('Root energy Vs Energy deficit and Accuracy')
    hold on;
%      legendTitle{1,br} = strcat('k= ',num2str(kk(br)));
%       legend(legendTitle{1,1:br}); hold off;

    end
   
end
% figure(1);
% 
% legend(legendTitle);
hold off;

% for i=1:1
% %     str = 'F:\Github_team\Vascular_Tree\Correlation_study\Task2_data\opti_k_' + string(kk(i)) + '_trial_'+  string(1)+ '.mat';
% %     load(str)
%     
%     R=corrcoef(deficiency ,accuracy_recheck );
% %     figure(2);scatter(deficiency ,accuracy_recheck ,100*ones(1,7),'filled');hold on;
% %     xlabel('Energy Deficiency');ylabel('Accuracy');
% %     title('Energy Deficiency Vs Accuarcy for each Root Energy');
%     strr(i) = R(1,2);
% end
% for i=1:3
%     strlabel(1,i) = 'k = ' + string(kk(i))+ ' R = ' + string(strr(i));
% end
% legend(strlabel)