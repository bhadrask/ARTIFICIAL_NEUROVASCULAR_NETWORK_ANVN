clc;clear all; close all;
mlp_epoch = 20000;
colorc = jet(100);
wallowable_fr = 0.2:0.2:1;

vas_ln_mat =[36,52,450];%[16,20,24,28,32,36,40,44,48,52,56,64,72,80,96,100:25:500];%[64,125:50:800];%525;%[64,100:25:900];%[64,100:25:500];%,350:25:575];%[64,100,200,300,400,425,450,475,500,525,550] ;%[64,100:25:575];%[64,100:100:400,475:5:525,550:25:700,800:100:2200];%,800:100:2200];%[64,100:100:1000];%[32,50:50:1000];%[16,256,512,768,1024,2048];
for j=1:size(vas_ln_mat,2)
    for i=1:size(wallowable_fr,2)
         wallowable = (wallowable_fr.*vas_ln_mat(j))/5000;
        %         str = strcat('C:\Users\Nagavarshini\Desktop\Newvascular\Vascular_Tree\Vascular_Tree\task_3_parallel\28_7\Neg_fb_27_t5',num2str(wallowable(i)),'_ln_',num2str(vas_ln_mat(j)),'.mat');
        %                 str = strcat('C:\Users\Nagavarshini\Desktop\Newvascular\Vascular_Tree\Vascular_Tree\task_3_parallel\7_8\matfiles\Neg_fb_incdata_',num2str(wallowable(i)),'_ln_',num2str(vas_ln_mat(j)),'.mat');
%                  str = strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_parallel\resolution_475_to_550\Neg_fb_inctest_',num2str(wallowable(i)),'_ln_',num2str(vas_ln_mat(j)),'.mat');
       
        % str = strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_parallel\negfb0.008\high_etavas_delefb_low_Neg_fb_inctest_',num2str(wallowable(i)),'_ln_',num2str(vas_ln_mat(j)),'.mat');
%         str = strcat('/home/sowmya/Desktop/adj_matrix_model/task_3_parallel/adapted_wallowable/high_etavas_delefb_low_Neg_fb_inctest_',num2str(wallowable(i)),'_ln_',num2str(vas_ln_mat(j)),'_trial_1.mat');
        str=strcat('D:\github_desktop\Vascular_Tree\task_3_parallel\adapted_wallowable\debug_525\negative_fb_-0.005\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
load(str);
        
%         save_name = sprintf('Neg_fb_incdata_%.2f_ln_%d.mat',wallowable(i),vas_ln_mat(j));
%         save(save_name,'percap_energy_con', 'mlp_train_success', 'mlp_test_success', 'dele', 'END_energy', 'init_energy');
        
         figure(j);
%   set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
%         %         plot(vas_ln*percap_energy_con(1:mlp_epoch),mlp_test_success(1:mlp_epoch),'color',colorc(10*i,:));
        plot(percap_energy_con(1:mlp_epoch),mlp_test_success(1:mlp_epoch),'color',colorc(20*i,:));
        
         hold on;
%         %         title(['Test accuracy vs Total energy consumption neurons ',string(vas_ln_mat(j))]);
        title(['Test accuracy vs Percapita energy consumption neurons for hidden neuron number ',num2str(vas_ln_mat(j))]);
%         %         xlabel('Total energy consumption');
         xlabel('Percapita energy consumption');
         ylabel('Test accuracy');xlim([0 1.5]);
%        
      
%         figure(2*j+1);
%         plot(1:mlp_epoch, mlp_test_success(1:mlp_epoch),'color',colorc(10*i,:));
%         hold on;
%         %         title(['Test accuracy vs Total energy consumption neurons ',string(vas_ln_mat(j))]);
%         title(['DelE vs Epochs',string(vas_ln_mat(j))]);
%         %         xlabel('Total energy consumption');
%         xlabel('Epoch');
%         ylabel('DelE');
       
        
        %         figure(size(vas_ln_mat,2)+j);
        %         plot(init_energy,'color',colorc(10*i,:));
        %         hold on;
        %         title(['Initial Energy Distribution across the Neurons',string(vas_ln_mat(j))]);
        %         xlabel('Neurons');
        %         ylabel('Intial Energy Distribution');
        
%         figure(2*size(vas_ln_mat,2)+j);
% %         plot(percap_energy_con(1:mlp_epoch),'color',colorc(10*i,:));
%         plot(mlp_test_success(1:mlp_epoch),'color',colorc(10*i,:));
%         hold on;
%         title(['Accuracy Vs Epochs',string(vas_ln_mat(j))]);
% %         title(['Test accuracy Vs Epochs',string(vas_ln_mat(j))]);
%         xlabel('Epochs');
%         ylabel('Accuracy');
% % %         %         wupdate(j,i) = sum(END_energy)/5000;
% % %         %         figure(10);plot(dele);pause(0.8);
%         figure(3*size(vas_ln_mat,2)+j);
%         plot(percap_energy_con(1:mlp_epoch),'color',colorc(10*i,:));
% %         plot(dele(1:mlp_epoch),'color',colorc(10*i,:));
%         hold on;
%         title(['Percapita vs epochs',string(vas_ln_mat(j))]);
%         xlabel('Epochs');
%         ylabel('Percapita');%ylim([0 3]);
        %         fprintf('Network size: %d Energy from Root: %d Del Energy: %d \n', vas_ln_mat(j), wallowable(i)*5000,dele(end));
        
    end
     hold off;
%        pause(0.5);
        
    for i=1:size(wallowable,2)
        strlabel(1,i) = 'Initial Energy = ' + string(wallowable(i)*vas_ln);
    end
    figure(j);
    legend(strlabel)
    
%     figure(2*j);
%     
%         figure(size(vas_ln_mat,2)+j);
%         legend(strlabel)
%     
%         figure(3*size(vas_ln_mat,2)+j);
%         legend(strlabel)
%     
end

