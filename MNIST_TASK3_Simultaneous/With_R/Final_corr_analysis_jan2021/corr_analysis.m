clear all;
close all;clc;
mlp_c1=5;
cnt=1;
load('mlp_test_labels.mat');
load('mlp_test_images.mat')
mlp_test_size=numel(mlp_test_labels);
wallowable_fraction = 0.4:0.2:1.8;

vas_ln_mat =[16,24,32,42,52,64,72,80,96,100:50:500];%[50:25:675];%[16,24,32,42,52,64,72,80,96,100:50:1000];%[16,32,64,100,300,500];%[16,24,32,42,52,64,72,80,96,100:25:500];%%[20:4:56,64,72,80,96,100:25:500];%[64,100:25:900];%[64,100:100:1000];%[32,50:50:1000];%[16,256,512,768,1024,2048];
for jj=1:numel(vas_ln_mat)
    wallowable = (wallowable_fraction.*vas_ln_mat(jj))./5000;
    for ii=1:numel(wallowable)
        str=strcat('ln_',num2str(vas_ln_mat(jj)),'_wallow_',num2str(wallowable(ii)),'_trial_1.mat');
        
        
        load(str);
        
        
        for i=1:vas_ln
            
            t2 = sigmf(mlp_w1*mlp_test_images - repmat(mlp_b1,1, mlp_test_size), [mlp_c1, 0]);
            t2o=t2;
            t2(i,:)=0;
            t3 = sigmf(mlp_w2*t2 - repmat(mlp_b2,1, mlp_test_size), [1, 0]);
            t3o=sigmf(mlp_w2*t2o - repmat(mlp_b2,1, mlp_test_size), [1, 0]);
            
            [~, tidx] = max(t3);
              [~, tidxo] = max(t3o);
              ydesired=zeros(size(t3));
              

              for pq=1:mlp_test_size
                ydesired(mlp_test_labels(pq) + 1,pq)=1;
              end
              RMSE_full_N(i)=mean(rms((ydesired-t3o),1));
              RMSE_removed_one_N(i)=mean(rms((ydesired-t3),1));
             
            success(i) = sum(tidx' == mlp_test_labels + 1)/mlp_test_size;
            successo(i) = sum(tidxo' == mlp_test_labels + 1)/mlp_test_size;
            Econsum(i)=END_energy(i);
%             mm(i)=max(END_energy);
            ERR(i)= successo(i)-success(i);
            
        end
        error_contri=RMSE_removed_one_N-RMSE_full_N;
        succ(jj,ii)=mean(successo);
        Esave(jj,ii)=sum(END_energy);
        newdd=corrcoef(error_contri,Econsum);
%         dd=corrcoef(ERR,Econsum);
%          if isnan(dd(1,2))
%             dd(1,2)=0;
%          else
       if isnan(newdd(1,2))
              newdd(1,2)=0;
        end
%         corr_coefficient(jj,ii)=dd(1,2);
%         error1(jj,ii)=min(success);
         new_corr_coefficient(jj,ii)=newdd(1,2);
       
    end
%     figure(1);
%     fig=figure(1);
%     members=[16,32,64,100,500];
%     if ismember(vas_ln,members)
%     subplot(numel(members),1,cnt);
%     cnt=cnt+1;
%     scatter(Econsum,error_contri,'filled');
% %     stem(END_energy);
%      title(['No: of Hidden Neurons= ',num2str(members(cnt-1))]);
%     end
end
% han=axes(fig,'visible','off'); 
% han.Title.Visible='on';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,'Delta RMSE by neuron j');
%      xlabel(han,'Energy Consumed by the neuron j')

figure(1);
yyaxis left
plot(vas_ln_mat,new_corr_coefficient);ylim([0,1]);
title([{'Correlation between energy consumption and'},{ 'error contribution across the hidden number'}]);
 xlabel('No. of Hidden Neurons'); ylabel ('Correlation coefficient')
 yyaxis right
 plot(vas_ln_mat,succ);ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex');ylim([0,1]);
 figure;
 yyaxis left
 NNew=mean(new_corr_coefficient,2);
figure(2);
yyaxis left
(plot(vas_ln_mat,NNew));ylim([0,1])
title([{'Correlation between energy consumption and'},{ 'error contribution across the hidden number'}]);
 xlabel('No. of Hidden Neurons'); ylabel ('Correlation coefficient')
 yyaxis right
 plot(vas_ln_mat,mean(succ*100,2));ylabel('Test Accuracy');ylim([0,100]);
 
 Eff=100*(succ-succ(1,:))./Esave;
 
 figure(3);
yyaxis left
(plot(vas_ln_mat,NNew));ylim([0,1]);
title([{'Correlation between energy consumption and'},{ 'error contribution across the hidden number'}]);
xlabel('No. of Hidden Neurons'); ylabel ('Correlation coefficient');
yyaxis right
plot(vas_ln_mat,mean(Eff,2));
ylim([0 1]);ylabel('Energy Efficiency');