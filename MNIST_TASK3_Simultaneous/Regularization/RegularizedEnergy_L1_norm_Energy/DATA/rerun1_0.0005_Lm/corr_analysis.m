clear all;
close all;clc;
mlp_c1=5;
cnt=1;
load('mlp_test_labels.mat');
load('mlp_test_images.mat')
mlp_test_size=numel(mlp_test_labels);
wallowable_fraction = 1;%0.2:0.2:1;

vas_ln_mat =[10:2:32,42,52,64,72,80,96,100:50:500];%[16,24,32,42,52,64,72,80,96,100:50:500];%[50:25:675];%[16,24,32,42,52,64,72,80,96,100:50:1000];%[16,32,64,100,300,500];%[16,24,32,42,52,64,72,80,96,100:25:500];%%[20:4:56,64,72,80,96,100:25:500];%[64,100:25:900];%[64,100:100:1000];%[32,50:50:1000];%[16,256,512,768,1024,2048];
for jj=1:numel(vas_ln_mat)
    wallowable = (wallowable_fraction.*vas_ln_mat(jj))./5000;
    for ii=1:numel(wallowable)
        str=strcat('F:\BHADRA\regularised_energy_data\FINAL_RUN_DEC_2020\corr_analysis_lamda0.0005\ln_',num2str(vas_ln_mat(jj)),'_wallow_',num2str(wallowable(ii)),'_trial_1.mat');
        
        
        load(str);
        
        
        for i=1:vas_ln
            
            t2 = sigmf(mlp_w1*mlp_test_images - repmat(mlp_b1,1, mlp_test_size), [mlp_c1, 0]);
            t2(i)=0;
            t3 = sigmf(mlp_w2*t2 - repmat(mlp_b2,1, mlp_test_size), [1, 0]);
            
            
            [~, tidx] = max(t3);
            success(i) = sum(tidx' == mlp_test_labels + 1)/mlp_test_size;
            Econsum(i)=END_energy(i);
            mm(i)=max(END_energy);
            ERR(i)=1-success(i);
            
        end
        dd=corrcoef(ERR,Econsum);
         if isnan(dd(1,2))
            dd(1,2)=0;
        end
        corr_coefficient(jj,ii)=dd(1,2);
        error1(jj,ii)=min(success);
       
    end
    figure(1);
    fig=figure(1);
    if ismember(vas_ln,[16,32,64,100])
    subplot(4,1,cnt);
    cnt=cnt+1;
    stem(END_energy);
%     xlabel('Neurons');
%     ylabel('Energy Consumed at steady state')
    end
end
han=axes(fig,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Energy Consumed at steady state');
xlabel(han,'Neurons');
title(han,'Energy consumed by each neuron in a network');
figure(2);
plot(vas_ln_mat,corr_coefficient);hold on;
plot(vas_ln_mat,error1);ylim([-0.1,1]);title('Correlation between energy consumption and error contribution');
xlabel('No. of Hidden Neurons'); ylabel ('Correlation coefficient and Test Success')