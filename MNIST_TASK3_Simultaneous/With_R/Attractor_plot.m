clc;
clear;
close all;

mlp_epoch = 20000;
colorc = jet(190);
wallowable_fraction =  0.2: 0.2:1;

vas_ln_mat =[20:4:56,64,72,80,96,100:25:500];%[64,100:25:900];%[64,100:100:1000];%[32,50:50:1000];%[16,256,512,768,1024,2048];
for j=1:numel(vas_ln_mat)
    wallowable = (wallowable_fraction.*vas_ln_mat(j))./5000;
    for i=1:numel(wallowable)
        % str = strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_parallel\negfb0.008\high_etavas_delefb_low_Neg_fb_inctest_',num2str(wallowable(i)),'_ln_',num2str(vas_ln_mat(j)),'.mat');
%         str = strcat('/home/sowmya/Desktop/adj_matrix_model/task_3_parallel/adapted_wallowable/debug_525/negative_fb_-0.005/ln_', num2str(vas_ln_mat(j)), '_wallow_', num2str(wallowable(i)), '_trial_1.mat');
        str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_parallel\adapted_wallowable\debug_525\negative_fb_-0.005\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
        % str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_k_ln_reservoir\adapted_wallowable\run2\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
        % str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_k_ln_reservoir\adapted_wallowable\random_wvasc\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');

        load(str);
        stracc(i,j) = (mlp_test_success(mlp_epoch));
        strtrain_acc(i,j) = (mlp_train_success(mlp_epoch));
        x = find(mlp_test_success == stracc(i,j));
        strper(i,j) = percap_energy_con(end);
        strvas(i,j) = vas_ln_mat(j);
        strtotal_energy(i,j) = percap_energy_con(end)*strvas(i,j);
    end
    
    figure(30);
    title('Distribution of Percapita energy consumption for various Hidden neurons');
    xlabel('Hidden Neuron');
    ylabel('Percapita energy consumption');
    scatter(strvas(:,j), strper(:,j), [],colorc(5*j,:),'filled', 'jitter','on', 'jitterAmount', 0.05);
    ylim([0 2]);
    hold on;
    
    % figure(31);
    % title(['Distribution of Test Accuracy for various Hidden neurons']);
    % xlabel('Hidden Neuron');
    % ylabel('Test Accuracy');
    % scatter(strvas(:,j), stracc(:,j), [],colorc(5*j,:),'filled', 'jitter','on', 'jitterAmount', 0.05);%ylim([0 2]);
    % hold on;
end
% sname = 'MyStyle2';
% S = hgexport('readstyle',sname);
% style.Format = 'png';
% style.ApplyStyle = '1';
% hgexport(gcf,'file_name',S,'applystyle',true);
% box on;
% hold off;
avg_percap = mean(strper,1);
avg_trainacc = mean(strtrain_acc,1);
avg_acc = mean(stracc,1);
avg_totalenergy = mean(strtotal_energy,1);

% avg_acc1 = mean(stracc1,1);
%%
figure;
yyaxis left
plot(strvas,avg_acc);
ylim([0 100]);
xlabel('Hidden Neuron');
ylabel('Test Accuracy');
yyaxis right
plot(strvas,avg_percap);
ylim([0 2]);
ylabel('Per capita Energy Consumption');
title(['Distribution of Percapita energy consumption and Accuracy for various Hidden neurons']);
% sname = 'MyStyle2';
% S = hgexport('readstyle',sname);
% style.Format = 'png';
% style.ApplyStyle = '1';
% hgexport(gcf,'file_name',S,'applystyle',true);

% figure;
% yyaxis left
% plot(strvas,avg_trainacc);ylim([0 100]);
% xlabel('Hidden Neuron');
% ylabel('Train Accuracy');
% yyaxis right
% plot(strvas,avg_percap);ylim([0 2]);
% ylabel('Per capita Energy Consumption');
% title(['Distribution of Percapita energy consumption and Accuracy for various Hidden neurons']);

figure;
yyaxis left
plot(strvas,avg_acc);
ylim([0 100]);
xlabel('Hidden Neuron');
ylabel('Test Accuracy');
yyaxis right
plot(strvas,avg_totalenergy);
ylabel('Total Energy Consumption');
title(['Distribution of Total energy consumption and Accuracy for various Hidden neurons']);
% sname = 'MyStyle2';
% S = hgexport('readstyle',sname);
% style.Format = 'png';
% style.ApplyStyle = '1';
% hgexport(gcf,'file_name',S,'applystyle',true);

% figure;
% yyaxis left
% plot(strvas,avg_trainacc);ylim([0 100]);
% xlabel('Hidden Neuron');
% ylabel('Train Accuracy');
% yyaxis right
% plot(strvas,avg_totalenergy);
% ylabel('Total Energy Consumption');
% title(['Distribution of Total energy consumption and Accuracy for various Hidden neurons']);
%%
figure(32);
boxplot(strper);
set(gca,'XTickLabel',num2cell(vas_ln_mat'))
title(['Distribution of Percapita energy consumption for various Hidden neurons']);
xlabel('Hidden Neuron');
ylabel('Percapita energy consumption');
ylim([0 2]);
% sname = 'MyStyle2';
% S = hgexport('readstyle',sname);
% style.Format = 'png';
% style.ApplyStyle = '1';
% hgexport(gcf,'file_name',S,'applystyle',true);

% hold on;
% for i = 1:3%size(wallowable,2)
% %     for j =1:size(vas_ln_mat,2)
%         plot(vas_ln_mat(i),strper(i,1));
% %     end
% end
% hold off;

%%
for i=1:size(vas_ln_mat,2)
    strlabel(1,i) = 'Hidden Neurons = ' + string(vas_ln_mat(i));
end
figure(30);
legend(strlabel, 'Location', 'Best','NumColumns',5)
% figure(31);
% legend(strlabel, 'Location', 'Best','NumColumns',5)

%%
% % wallowable_fraction = 0.2: 0.2:1;
% % vas_ln_mat =[64,125:50:800];%[64,100:25:900];
% cn=50;
% for j=1:numel(vas_ln_mat)
%     figure('units','normalized','outerposition',[0 0 1 1])
%     wallowable = (wallowable_fraction.*vas_ln_mat(j))./5000;
%     for i=1:numel(wallowable)
%         str = strcat('/home/sowmya/Desktop/adj_matrix_model/task_3_parallel/adapted_wallowable/debug_525/negative_fb_-0.005/ln_', num2str(vas_ln_mat(j)), '_wallow_', num2str(wallowable(i)), '_trial_1.mat');
%         load(str);
%         subplot(1,2,1)
%         plot(init_energy, '.', 'MarkerSize',15);
%         hold on;
%         str = "Initial energy Distribution; Neurons:" + string(vas_ln);
%         title(str)
%         xlabel('Hidden Neurons')
%         ylabel('Energy')
% 
%         subplot(1,2,2)
%         plot(END_energy, '.', 'MarkerSize',15);
%         hold on;
%         str = "Final energy Distribution; Neurons:" + string(vas_ln);
%         title(str)
%         xlabel('Hidden Neurons')
%         ylabel('Energy')
%         
%         % figure(50+cn);subplot(121);histogram(init_energy);
%         % subplot(122);histogram(END_energy);
%         % cn=cn+1;
%     end
%     subplot(1,2,1)
%     legend("W allowable: 0.2", "W allowable: 0.4", "W allowable: 0.6", "W allowable: 0.8", "W allowable: 1.0", 'Location','northwest');
%     subplot(1,2,2)
%     legend("W allowable: 0.2", "W allowable: 0.4", "W allowable: 0.6", "W allowable: 0.8", "W allowable: 1.0", 'Location','northwest');
%     sname = 'MyStyle2';
%     S = hgexport('readstyle',sname);
%     style.Format = 'png';
%     style.ApplyStyle = '1';
%     hgexport(gcf,'file_name',S,'applystyle',true);
% end
% 
% %%
% for j=1:numel(vas_ln_mat)
%     figure('units','normalized','outerposition',[0 0 1 1])
%     wallowable = (wallowable_fraction.*vas_ln_mat(j))./5000;
%     for i=1:numel(wallowable)
%         str = strcat('/home/sowmya/Desktop/adj_matrix_model/task_3_parallel/adapted_wallowable/debug_525/negative_fb_-0.005/ln_', num2str(vas_ln_mat(j)), '_wallow_', num2str(wallowable(i)), '_trial_1.mat');
%         load(str);
%         plot(dele);
%         hold on;
%         str = "delE; Neurons:" + string(vas_ln);
%         title(str)
%         xlabel('Hidden Neurons')
%         ylabel('delE')
%     end
%     legend("Wallowable: 0.2", "Wallowable: 0.4", "Wallowable: 0.6", "Wallowable: 0.8", "Wallowable: 1.0", 'Location','northwest');
%     sname = 'MyStyle2';
%     S = hgexport('readstyle',sname);
%     style.Format = 'png';
%     style.ApplyStyle = '1';
%     hgexport(gcf,'file_name',S,'applystyle',true);
% end
% 
% %%
% colorc = jet(5);
% cd /home/sowmya/Desktop/adj_matrix_model/task_3_parallel/Journal_task3R_MNIST/best_images
% for j=1:size(vas_ln_mat,2)
%     % figure('units','normalized','outerposition',[0 0 1 1])
%     figure;
%     wallowable = (wallowable_fraction.*vas_ln_mat(j))./5000;
%     for i=1:numel(wallowable)
%         str = strcat('/home/sowmya/Desktop/adj_matrix_model/task_3_parallel/adapted_wallowable/debug_525/negative_fb_-0.005/ln_', num2str(vas_ln_mat(j)), '_wallow_', num2str(wallowable(i)), '_trial_1.mat');
%         % str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_parallel\adapted_wallowable\debug_525\negative_fb_-0.003\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
%         load(str);
%         plot(percap_energy_con(1:mlp_epoch), mlp_test_success(1:mlp_epoch),'color',colorc(i,:));
%         hold on;
%         str = "Test accuracy vs Percapita energy consumption; Neurons:" + string(vas_ln);
%         title(str);
%         ylim([0 100]);
%         xlim([0 2]);
%         xlabel('Percapita energy consumption');
%         ylabel('Test accuracy');
%     end
%     legend("W allowable: 0.2", "W allowable: 0.4", "W allowable: 0.6", "W allowable: 0.8", "W allowable: 1.0", 'Location','northeast');
%     sname = 'MyStyle2';
%     S = hgexport('readstyle',sname);
%     style.Format = 'png';
%     style.ApplyStyle = '1';
%     hgexport(gcf,'file_name',S,'applystyle',true);
%     fname = "ln_" + string(vas_ln_mat(j)) + ".png";
%     exportgraphics(gcf, fname, 'Resolution', 500)
%     fname = "ln_" + string(vas_ln_mat(j)) + ".eps";
%     exportgraphics(gcf, fname)
% end
% 
% cd ..
% cd ..
% cd ..