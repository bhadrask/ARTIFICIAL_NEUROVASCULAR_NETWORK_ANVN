clc;
clear;
% close all;
image_settings;
mlp_epoch = 20000;
colorc = jet(190);
wallowable_fraction = 0.4:0.2:3;

vas_ln_mat =[16,24,32,42,52,64,72,80,96,100:50:500];%[50:25:675];%[16,24,32,42,52,64,72,80,96,100:50:1000];%[16,32,64,100,300,500];%[16,24,32,42,52,64,72,80,96,100:25:500];%%[20:4:56,64,72,80,96,100:25:500];%[64,100:25:900];%[64,100:100:1000];%[32,50:50:1000];%[16,256,512,768,1024,2048];
for j=1:numel(vas_ln_mat)
    wallowable = (wallowable_fraction.*vas_ln_mat(j))./5000;
    for i=1:numel(wallowable)
%              str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task3_parallel_R_regularisedEnergy\rerun1_0.0002_Lm\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
         str=strcat('F:\BHADRA\regularised_energy_data\FINAL_RUN_DEC_2020\rerun1_0_Lm\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
        % str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_k_ln_reservoir\adapted_wallowable\random_wvasc\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');

        load(str);
        stracc(i,j) = (mlp_test_success(mlp_epoch));
        strtrain_acc(i,j) = (mlp_train_success(mlp_epoch));
        x = find(mlp_test_success == stracc(i,j));
        strper(i,j) = percap_energy_con(end);
        strvas(i,j) = vas_ln_mat(j);
        strtotal_energy(i,j) = percap_energy_con(end)*strvas(i,j);
    end
    
%     figure(30);
%     title('Distribution of Percapita energy consumption for various Hidden neurons');
%     xlabel('Hidden Neuron');
%     ylabel('Percapita energy consumption');
%     scatter(strvas(:,j), strper(:,j), [],colorc(5*j,:),'filled', 'jitter','on', 'jitterAmount', 0.05);
%     ylim([0 2]);
%     hold on;
    
  
end

avg_percap = mean(strper,1);
avg_trainacc = mean(strtrain_acc,1);
avg_acc = mean(stracc,1);
avg_totalenergy = mean(strtotal_energy,1);


%%
% figure;
yyaxis left
plot(strvas(1,:),avg_acc);
ylim([0 100]);
xlabel('Hidden Neuron');
ylabel('Test Accuracy');
yyaxis right
plot(strvas(1,:),avg_percap);
ylim([0 2]);
ylabel('Per capita Energy Consumption');
title(['Distribution of Percapita energy consumption and Accuracy for various Hidden neurons']);


% figure;
% yyaxis left
% plot(strvas(1,:),avg_acc);
% ylim([0 100]);
% xlabel('Hidden Neuron');
% ylabel('Test Accuracy');
% yyaxis right
% plot(strvas(1,:),avg_totalenergy);
% ylabel('Total Energy Consumption');
% title(['Distribution of Total energy consumption and Accuracy for various Hidden neurons']);

%%
% figure(32);
% boxplot(strper);
% set(gca,'XTickLabel',num2cell(vas_ln_mat'))
% title(['Distribution of Percapita energy consumption for various Hidden neurons']);
% xlabel('Hidden Neuron');
% ylabel('Percapita energy consumption');
% ylim([0 2]);


%%
% for i=1:size(vas_ln_mat,2)
%     strlabel(1,i) = 'Hidden Neurons = ' + string(vas_ln_mat(i));
% end
% figure(30);
% legend(strlabel, 'Location', 'Best','NumColumns',5)
% figure(31);
% legend(strlabel, 'Location', 'Best','NumColumns',5)



