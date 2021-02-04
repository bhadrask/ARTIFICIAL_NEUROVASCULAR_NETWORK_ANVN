%
clear; clc;close all;
en=[10:10:100,200:100:1000];
trial=1:1;
K=[16,64,256];%[2,3,4,6,8,32,512];
ACC=zeros(numel(K),numel(en));
efficiency=zeros(numel(K),numel(en));
for tr=1:numel(trial)
    for k=1:numel(K)
        for i=1:numel(en)
            str =  'LN64k_'+string(K(k))+'_energy_' + string(en(i)) +'_Trial_'+string(tr)+'.mat';
            load(str);
            acc(i)=mlp_test_success(end);
        end
        ACC(k,:)=ACC(k,:)+acc;
        Acc_trials{k,tr}=acc;
        eff=(acc-acc(1))./en;
        efficiency(k,:)=efficiency(k,:)+eff;
         
        Eff_trials{k,tr}=eff;
    end
end
        ACC=ACC/numel(trial);
        efficiency=efficiency/numel(trial);
                figure(1);
        plot(en,ACC); hold on;
        legend('2','3','4','6','8','32','512');
        figure(2);
        yyaxis left;ylim([0,1]);
        plot(en,ACC/100); xlabel('Energy at Root Node');
        ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
        hold on;
        yyaxis right;ylim([0,1]);
        plot(en,efficiency);ylabel('Normalized Energy Efficiency');hold on;
        
        legend('2','3','4','6','8','32','512');
%             save('task3_noR_MNIST_data_final_2021.mat','en','ACC','efficiency');
evec=en;
 for j=K
chosenk=find(K==j);
for i=1:tr
    acc_chosen(i,:)=Acc_trials{chosenk,i}/100;
    eff_chosen(i,:)=Eff_trials{chosenk,i};
end

mean_acc=mean(acc_chosen,1);
mean_eff=mean(eff_chosen,1);
std_acc=std(acc_chosen,1);
std_eff=std(eff_chosen,1);
opt = {'k','Linew',2,'LineS','none'};

figure();
       yyaxis left ;ylim([0,1]);
    plot(evec,ACC(chosenk,:)/100); hold on;
    errorbar(evec,mean_acc,std_acc,opt{:});
    xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right;ylim([0,1]);
    plot(evec,efficiency(chosenk,:)); hold on;
        errorbar(evec,mean_eff,std_eff,opt{:});
    ylabel('Normalized Energy Efficiency');
    title(['Branching=',num2str(j)]);
end
