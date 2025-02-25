clear all;
close all;clc;
mlp_c1=5;
cnt=1;
load('mlp_test_labels.mat');
load('mlp_test_images.mat')
mlp_test_size=numel(mlp_test_labels);

en=[10:10:100,200:100:500];
trial=1;%3;
K=[2,3,4,6,8,16,32,64,256,512];

for tr=1:numel(trial)
    for k=1:numel(K)
        for ii=1:numel(en)
            str =  'k_'+string(K(k))+'_energy_' + string(en(ii)) +'_Trial_'+string(tr)+'.mat';
            load(str);
            END_energy=tree_Energy_save(numel(tree_Energy_save)-vas_ln+1:end);
            for i=1:vas_ln
                t2 = sigmf(mlp_W1*mlp_test_images - repmat(mlp_b1,1, mlp_test_size), [mlp_c1, 0]);
                t2o=t2;
                t2(i,:)=0;
                t3 = sigmf(mlp_W2*t2 - repmat(mlp_b2,1, mlp_test_size), [1, 0]);
                t3o=sigmf(mlp_W2*t2o - repmat(mlp_b2,1, mlp_test_size), [1, 0]);
                
                [~, tidx] = max(t3);
                [~, tidxo] = max(t3o);
                
                      ydesired=zeros(size(t3));
              

              for pq=1:mlp_test_size
                ydesired(mlp_test_labels(pq) + 1,pq)=1;
              end
                RMSE_full_N(i)=mean(rms((ydesired-t3o),1));
                RMSE_removed_one_N(i)=mean(rms((ydesired-t3),1));
                Econsum(i)=END_energy(i);
                   success(i) = sum(tidxo' == mlp_test_labels + 1)/mlp_test_size;
            end
          SUCC(k,ii)=mean(success);
            clear success;
            error_contri=RMSE_removed_one_N-RMSE_full_N;
            ErCon(ii,:)= error_contri;
            newdd=corrcoef(error_contri,Econsum);
            
            if isnan(newdd(1,2))
                newdd(1,2)=0;
            end
            
            new_corr_coefficient(k,ii)=newdd(1,2);
           
       
%         figure(1);
%         fig=figure(1);
%         members=[10,30,100,200,400,500];
%         if ismember(en(ii),members)
%             subplot(numel(members),1,cnt);
%             cnt=cnt+1;
%             scatter(Econsum,error_contri,'filled');
%             %     stem(END_energy);
%             title(['Input energy= ',num2str(members(cnt-1))]);
%         end
        end
   
    figure(k);
yyaxis left

plot(en,new_corr_coefficient(k,:));ylim([0,1]); hold on;
title([{'Correlation between energy consumption and'},{ 'error contribution across the input energy'}]);
xlabel('Input Energy'); ylabel ('Correlation coefficient');
yyaxis right

plot(en,100*SUCC(k,:));
ylim([0 1]);ylabel ('Test accuracy');hold on;

 end
end
% han=axes(fig,'visible','off');
% han.Title.Visible='on';
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,'Delta RMSE by neuron j');
% xlabel(han,'Energy Consumed by the neuron j')


NNew=mean(new_corr_coefficient,1);

figure;
yyaxis left
(plot(en,NNew));ylim([0,1]);
title([{'Correlation between energy consumption and'},{ 'error contribution across the input energy'}]);
xlabel('Input Energy'); ylabel ('Correlation coefficient');
yyaxis right

plot(en,100*mean(SUCC,1));
ylim([0 100]);ylabel('Test Accuracy');

effi=100*(SUCC-SUCC(:,1))./en;


figure;
yyaxis left
(plot(en,NNew));ylim([0,1]);
title([{'Correlation between energy consumption and'},{ 'error contribution across the input energy'}]);
xlabel('Input Energy'); ylabel ('Correlation coefficient');
yyaxis right
plot(en,mean(effi,1));
ylim([0 1]);ylabel('Energy Efficiency');