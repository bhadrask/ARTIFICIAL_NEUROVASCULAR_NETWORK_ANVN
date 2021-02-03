%
clear; clc;close all;
en=[1,10:10:100,200:100:500];
trial=1:3;
K=[2,3,4,6,8,32,512];
ACC=zeros(numel(K),numel(en));
efficiency=zeros(numel(K),numel(en));
for tr=1:numel(trial)
    for k=1:numel(K)
        for i=1:numel(en)
            str =  'k_'+string(K(k))+'_energy_' + string(en(i)) +'_Trial_'+string(tr)+'.mat';
            load(str);
            acc(i)=mlp_test_success(end);
        end
        ACC(k,:)=ACC(k,:)+acc;

        eff=acc./en;
        efficiency(k,:)=efficiency(k,:)+eff./max(eff);
    end
end
        ACC=ACC/numel(trial);
        efficiency=efficiency/numel(trial);
                figure(1);
        plot(en,ACC); hold on;
        legend('2','3','4','6','8','32','512');
        figure(2);
        yyaxis left
        plot(en,ACC/100); xlabel('Energy at Root Node');
        ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
        hold on;
        yyaxis right
        plot(en,efficiency);ylabel('Normalized Energy Efficiency');hold on;
        
        legend('2','3','4','6','8','32','512');
%             save('task3_noR_MNIST_data_final_2021.mat','en','ACC','efficiency');
        %% section2
        
        % k=[2,3,4,6,8,32,512];
        % energy_mat = [1,10:10:100,200:100:1000];
        % locs=2:find(energy_mat==500);
        % sel_energy=energy_mat(locs);
        % Acc=zeros(numel(k),numel(sel_energy));
        % efficiency=zeros(numel(k),numel(sel_energy));
        % for tr=[1,3,5]
        % for j=1:numel(k)
        %
        %
        %     load('opti_k_'+string(k(j))+'_trial_'+string(tr)+'.mat');
        %     Acc(j,:)=Acc(j,:)+accuracy_recheck(locs)';
        %     evec=sel_energy;
        % %     figure(tr);
        % %     plot(evec,accuracy_recheck(2:end)); hold on;
        %
        % %     figure(tr+1);
        % %     plot(evec,Acc); hold on;
        % %
        %     efficiency1=Acc(j,:)./evec;
        % efficiency(j,:)=efficiency(j,:)+efficiency1./max(efficiency1);
        %
        % end
        % end
        %
        %   Acc=Acc/3;
        %   efficiency=efficiency/3;
        %   for i=1:numel(k)
        % figure(1);
        %        yyaxis left
        %     plot(evec,Acc(i,:)/100); xlabel('Energy at Root Node');
        %     ylabel('$\frac{Test Accuracy}{100}$','Interpreter','latex')
        %     hold on;
        %        yyaxis right
        %     plot(evec,efficiency(i,:));ylabel('Normalized Energy Efficiency');
        %     hold on;
        %   end
        %
        %     save('task2_MNIST_data_final_2021.mat','evec','Acc','efficiency');
        % figure(1);legend('2','3','4','6','8','32','512');
        % % figure(2);legend('2','3','4','6','8','32');
        % figure(3);legend('2','3','4','6','8','32')