clc;
clear;
close all;
image_settings;
mlp_epoch = 20000;
colorc = jet(190);
wallowable_fraction = 0.4;%0.2: 0.2:1;

vas_ln_mat =[16,24,32,42,52,64,72,80,96,100:25:450];%[16,32,64,100,300,500];%[16,24,32,42,52,64,72,80,96,100:25:500];%%[20:4:56,64,72,80,96,100:25:500];%[64,100:25:900];%[64,100:100:1000];%[32,50:50:1000];%[16,256,512,768,1024,2048];
for compare=1:3
for j=1:numel(vas_ln_mat)
    wallowable = (wallowable_fraction.*vas_ln_mat(j))./5000;
    for i=1:numel(wallowable)
        if compare==1
            str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task3_parallel_R_regularized\run5_0.5_lambda\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
        elseif compare==2
             str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task3_parallel_R_regularized\run7_5_lambda\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
        elseif compare==3
             str=strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task3_parallel_R_regularized\run8_no_reg\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
      
        end
        load(str);

        A(j,i)=mean(mean(abs(mlp_w2)));
        B(j,i)=mean(mlp_b1);
        
    end
end
plot(vas_ln_mat,A)
hold on;
plot(vas_ln_mat,B)
hold on;
xlabel('number of hidden neurons')

title('Mean bias and mean weight across hidden neurons')
end
legend('mean Ws, lam=0.5','mean bias, lam=0.5','mean Ws, lam=5','mean bias, lam=5','mean Ws, lam=0','mean bias, lam=0');