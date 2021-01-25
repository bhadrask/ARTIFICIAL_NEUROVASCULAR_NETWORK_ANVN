clear all;
close all;
clc;
vas.energy_mat = [10:10:100,200:100:500];
branching =[2,3,4,6,8,32,512];
chosen_k=32;
loc_comp=find(branching==chosen_k);

colorc = jet(100);
fr=floor(100/numel(branching));
%% TASK 1 : UNTRAINED
load('task1_MNIST_data_final_2021.mat')
loc=1:numel(vas.energy_mat);
 EFFnew=zeros(size(efficiency(:,loc)));

      
for k =1:numel(branching)
    EFFnew(k,:)=(ACC(k,loc)-ACC(1))./vas.energy_mat(loc);
    EFFnew(EFFnew<0)=0;
  figure(1);  plot(vas.energy_mat, ACC(k,loc),'color',colorc(fr*k,:));ylim([0 100]); hold on;
            title(['Accuracy Vs Root node energy: Untrained'])
        ylabel('Accuracy')
        xlabel('Root node energy');
hold on;

figure(2);
       yyaxis left
       ylim([0,1])
    plot(Energy(loc),ACC(k,loc)/100); xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right; ylim([0,1])
    plot(Energy(loc),EFFnew(k,loc));ylabel('Normalized Energy Efficiency');
     
    hold on;
end
legend('k=2','k=3','k=4','k=6','k=8','k=32','k=512');
figure(10);

 yyaxis left
       ylim([0,1])
    plot(Energy(loc),ACC(loc_comp,loc)/100); xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right
    plot(Energy(loc),EFFnew(loc_comp,loc));ylabel('Normalized Energy Efficiency');
      title('Accuracy and Efficiency vs Root energy: Untrained')
    hold on;
%% Sequential Training


load('task2_MNIST_data_final_2021.mat');
EFFnew=zeros(size(efficiency(:,loc)));
for k =1:numel(branching)
     EFFnew(k,:)=(Acc(k,loc)-Acc(1))./vas.energy_mat(loc);
    EFFnew(EFFnew<0)=0;
  figure(3);  plot(vas.energy_mat, Acc(k,:),'color',colorc(fr*k,:));ylim([0 100]);hold on;
            title('Accuracy vs Root node energy: Sequential Training')
        ylabel('Accuracy')
        xlabel('Root node energy');
        figure(4);
       yyaxis left
       ylim([0,1])
    plot(evec,Acc(k,:)/100); xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right;  ylim([0,1])
    plot(evec,EFFnew(k,:));ylabel('Normalized Energy Efficiency');
    title('Accuracy and Efficiency vs Root energy: Sequential Training');
    hold on;
    disp(['sequential k=',num2str(branching(k)),', maxeff=',num2str(max(EFFnew(k,:))),', at root E=',num2str(Energy(find(EFFnew(k,:)==max(EFFnew(k,:)))))])
end
figure(3);legend('k=2','k=3','k=4','k=6','k=8','k=32','k=512');

figure(10);

 yyaxis left
       ylim([0,1])
    plot(Energy(loc),Acc(loc_comp,loc)/100); xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right
    plot(Energy(loc),EFFnew(loc_comp,loc));ylabel('Normalized Energy Efficiency');
      
    hold on;
%% Task3 without R
load('task3_noR_MNIST_data_final_2021.mat');
EFFnew=zeros(size(efficiency(:,loc)));
for k =1:numel(branching)
     EFFnew(k,:)=(ACC(k,loc)-ACC(1))./vas.energy_mat(loc);
    EFFnew(EFFnew<0)=0;
  figure(5);  plot(vas.energy_mat, ACC(k,:),'color',colorc(fr*k,:));ylim([0 100]);hold on;
            title('Accuracy vs Root node energy: Simultaneous  Training')
        ylabel('Accuracy')
        xlabel('Root node energy');
        figure(6);
       yyaxis left
       ylim([0,1])
    plot(evec,ACC(k,:)/100); xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right; ylim([0,1]);
    plot(evec,EFFnew(k,:));ylabel('Normalized Energy Efficiency');
    title('Accuracy and Efficiency vs Root energy: Simultaneous Training');
    hold on;
      disp(['k=',num2str(branching(k)),', maxeff=',num2str(max(EFFnew(k,:))),', at root E=',num2str(Energy(find(EFFnew(k,:)==max(EFFnew(k,:)))))])

end

figure(10);

 yyaxis left
       ylim([0,1])
    plot(Energy(loc),ACC(loc_comp,loc)/100); xlabel('Energy at Root Node');
    ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
    hold on;
       yyaxis right
    plot(Energy(loc),EFFnew(loc_comp,loc));ylabel('Normalized Energy Efficiency');
      title('Accuracy and Efficiency vs Root energy: comparison of all 3 regimes')
    hold on;
    legend('Untrained','sequential','simultaneous');