clear; clc;
wallowable_fraction = 1;% 0.2: 0.2:1;
k=16;
vas_ln_mat =[10:20:100,150:50:500];%[64,100:25:900];%[64,100:100:1000];%[32,50:50:1000];%[16,256,512,768,1024,2048];

for j=1:numel(vas_ln_mat)
    wallowable = (wallowable_fraction.*vas_ln_mat(j))./5000;
% load('C:\Users\Nagavarshini\Desktop\Newvascular\Vascular_Tree\Vascular_Tree\results\task1\512.mat')

   Cvec=0;
     for rep=1:1     
        str = strcat('C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\task_3_parallel\for_cor_study\ln_',num2str(vas_ln_mat(j)),'_wallow_',num2str(wallowable),'_trial_1.mat');
        
        load(str);
%         A_sum(j,:)=sum(mlp_w2,2)/vas_ln_mat(j);
%         A_abs(j,:)=sum(abs(mlp_w2),2)/vas_ln_mat(j);
            
            Amax=max(max(mlp_w2));
            Amin=min(min(mlp_w2));
            Mn=mean(mean(mlp_w2));
            Max(j)=Amax;
            Min(j)=Amin;
            Mean(j)=Mn;
     end
end
figure
plot(vas_ln_mat,Max,vas_ln_mat,Min,vas_ln_mat,Mean);
xlabel('No:of hidden neurons');

legend('Max','Min','Mean')
