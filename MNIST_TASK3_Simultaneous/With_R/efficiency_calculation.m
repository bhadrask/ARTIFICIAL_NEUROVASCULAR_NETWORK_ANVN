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
          str=strcat('D:\github_desktop\Vascular_Tree\task_3_parallel\adapted_wallowable\debug_525\negative_fb_-0.005\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable(i)),'_trial_1.mat');
          load(str);
       stracc(i,j) = (mlp_test_success(mlp_epoch));
       efficiency(i,j)= stracc(i,j)/sum(END_energy);
       energy(i,j)=sum(END_energy);
    end
end
eff=efficiency./max(efficiency,[],2);
figure();
for j=1:numel(wallowable_fraction)
       yyaxis left
    plot(vas_ln_mat,stracc(j,:)/100); xlabel('Number of neurons in the hidden layer');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right
    plot(vas_ln_mat,eff(j,:));ylabel('Normalized Energy Efficiency'); hold on;
end
% legend('0.2','0.4','0.6','0.8','1');

