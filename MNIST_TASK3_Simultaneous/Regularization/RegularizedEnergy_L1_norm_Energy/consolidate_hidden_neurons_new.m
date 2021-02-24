clc;clear; close all;
mlp_epoch = 20000;
colorc = jet(100);
wallowable_fr =0.2:0.2:3;%[2,3,4:0.4:6,10:15,25:30];
colorfac=floor(100/numel(wallowable_fr ));
vas_ln_mat =500;%[90,100,200,300,500];%500]%,200,300,400,500];%[64,100,200,500];%[16,24,32,2,52,64,72,80,96,100:50:500];%[16,32,64,100,300,500];%[16,20,24,28,32,36,40,44,48,52,56,64,72,80,96,100:25:500];%[64,125:50:800];%525;%[64,100:25:900];%[64,100:25:500];%,350:25:575];%[64,100,200,300,400,425,450,475,500,525,550] ;%[64,100:25:575];%[64,100:100:400,475:5:525,550:25:700,800:100:2200];%,800:100:2200];%[64,100:100:1000];%[32,50:50:1000];%[16,256,512,768,1024,2048];
for j=1:size(vas_ln_mat,2)
    for i=1:size(wallowable_fr,2)
         wallowable = (wallowable_fr.*vas_ln_mat(j))/5000;
      str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task3_parallel_R_regularisedEnergy\rerun1_0_Lm\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
       
        load(str);
        
         figure(j);
      plot(percap_energy_con(1:mlp_epoch),mlp_test_success(1:mlp_epoch),'color',colorc(colorfac*i,:));
        
         hold on;
%         %         title(['Test accuracy vs Total energy consumption neurons ',string(vas_ln_mat(j))]);
        title(['hidden neuron number ',num2str(vas_ln_mat(j))]);
%         %         xlabel('Total energy consumption');
         xlabel('Percapita energy consumption');
         ylabel('Test accuracy');

       
%       
         figure(numel(vas_ln_mat)+j);
        plot(1:mlp_epoch, mlp_test_success(1:mlp_epoch),'color',colorc(colorfac*i,:));
        hold on;
         title(['success vs Epochs',string(vas_ln_mat(j))]);
%     
        xlabel('Epoch');
        ylabel('Test Accuracy');
% 
% 
         figure(2*numel(vas_ln_mat)+j);
         plot(percap_energy_con(1:mlp_epoch),'color',colorc(colorfac*i,:));

         hold on;
         title(['Percapita vs epochs',string(vas_ln_mat(j))]);
        xlabel('Epochs');
        ylabel('Percapita'); 
%         
%          figure(3*numel(vas_ln_mat)+j);
% plot(Ejterm1-Ejterm2);title('hidden_layer terms');hold on;% plot(Ejterm2);hold on;
%          figure(4*numel(vas_ln_mat)+j);
% plot(Error(1:end));title('Output layer terms');hold on; %plot(Ejterm2);hold on;
    end
     hold off;
%        pause(0.5);
        
    for i=1:size(wallowable,2)
        strlabel(1,i) = 'Initial Energy = ' + string(wallowable_fr(i));
    end
    figure(j);
    legend(strlabel);
    
 figure(numel(vas_ln_mat)+j);
 legend(strlabel);
  figure(2*numel(vas_ln_mat)+j);
 legend(strlabel);
    

%     
end


