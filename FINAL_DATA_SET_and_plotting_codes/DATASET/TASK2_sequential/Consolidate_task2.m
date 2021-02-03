% 
 clear; clc;close all;
% en=[10:10:100,200:100:1000];
% for i=1:numel(en)
%     en(i)
% str =  'k_2_energy_' + string(en(i)) +'_Trial_3.mat';
%         load(str);
%         acc(i)=mlp_test_success(end);
% end
% figure(1);
% plot(en,acc); hold on;
%     efficiency=acc./en;
% efficiency=efficiency./max(efficiency);
% figure(2);
%        yyaxis left
%     plot(en,acc/100); xlabel('Energy at Root Node');
%     ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
%     hold on;
%        yyaxis right
%     plot(en,efficiency);ylabel('Normalized Energy Efficiency');hold on;
%% section2

k=[2,3,4,6,8,32,512];
energy_mat = [1,10:10:100,200:100:1000];
locs=2:find(energy_mat==500);
sel_energy=energy_mat(locs);
Acc=zeros(numel(k),numel(sel_energy));
efficiency=zeros(numel(k),numel(sel_energy));
tr1=[1,3,5,6,7,9];
cn=0;
for tr=tr1
    cn=cn+1;
for j=1:numel(k)
   
    
    load('opti_k_'+string(k(j))+'_trial_'+string(tr)+'.mat');
    Acc(j,:)=Acc(j,:)+accuracy_recheck(locs)';
    Acc_trials{j,cn}=accuracy_recheck(locs);
    evec=sel_energy;
%     figure(tr);
%     plot(evec,accuracy_recheck(2:end)); hold on;
 
%     figure(tr+1);
%     plot(evec,Acc); hold on;
%     
    efficiency1=(accuracy_recheck(locs)'-accuracy_recheck(locs(1)))./evec;
efficiency(j,:)=efficiency(j,:)+efficiency1;
Eff_trials{j,cn}=efficiency1;

end
end

  Acc=Acc/numel(tr1);
  efficiency=efficiency/numel(tr1);
  for i=1:numel(k)
figure(1);
       yyaxis left; ylim([0,1]);
    plot(evec,Acc(i,:)/100); xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right; ylim([0,1]);
    plot(evec,efficiency(i,:));ylabel('Normalized Energy Efficiency');
    hold on;
    disp(['k=',num2str(k(i)),', maxeff=',num2str(max(efficiency(i,:))),', at root E=',num2str(evec(find(efficiency(i,:)==max(efficiency(i,:)))))])

  end%      save('new_eff_task2_MNIST_data_final_2021.mat','evec','Acc','efficiency');
figure(1);legend('2','3','4','6','8','32','512');
% figure(2);legend('2','3','4','6','8','32');
% figure(3);legend('2','3','4','6','8','32')
cn=0;
for j=k
    cn=cn+1;
chosenk=find(k==j);
for i=1:numel(tr1)
    acc_chosen(i,:)=Acc_trials{chosenk,i}/100;
    eff_chosen(i,:)=Eff_trials{chosenk,i};
end
acc_prev=acc_chosen;
if cn>2
    [h,p]=ttest2(acc_chosen,acc_prev);
    if h==1
        keyboard;
    end
end
mean_acc=mean(acc_chosen,1);
mean_eff=mean(eff_chosen,1);
std_acc=std(acc_chosen,1);
std_eff=std(eff_chosen,1);
opt = {'k','Linew',2,'LineS','none'};

figure();
       yyaxis left ;ylim([0,1]);
    plot(evec,Acc(chosenk,:)/100); hold on;
    errorbar(evec,mean_acc,std_acc,opt{:});
    xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right;ylim([0,1]);
    plot(evec,efficiency(chosenk,:)); hold on;
        errorbar(evec,mean_eff,std_eff,opt{:});
    ylabel('Normalized Energy Efficiency');
    title(['Branching=',num2str(j)]);
    hold on;
end
%% paired t test
% for i=1:numel(k)
% for j=1:numel(k)
% [h(i,j),p(i,j)]=ttest2(efficiency(i,:),efficiency(j,:));
% end
% end
% save('new_eff_task2_MNIST_data_final_2021.mat','evec','Acc','efficiency','Acc_trials','Eff_trials');
