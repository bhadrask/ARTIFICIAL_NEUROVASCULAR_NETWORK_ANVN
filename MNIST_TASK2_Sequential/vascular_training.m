function [vas,savee1,saveb1,acc] = vascular_training(vas, tree, btarget,branching,l)
for i = 1:vas.trials
    vas.tree(i) = tree;
    vas.energy_in = vas.energy_mat(i);
    vas.tree(i).Energy = [vas.energy_in; zeros(vas.tree(i).Ntot-1,1)];
    
    fprintf('Energy: %d\n', vas.energy_in);
    
    %     adam.mb1 = zeros (vas.ln,2);
    %     adam.vb1 = zeros (vas.ln,2);
    % figure;
    for epoch = 1:vas.epoch
        vas.tree(i) = energy_flow(vas.tree(i),vas.energy_in);
        %         savee1(epoch,:,i) = vas.tree(i).Energy(vas.tree(i).leaf_idx);
        if epoch == vas.epoch
            savee1(i,:) = vas.tree(i).Energy(vas.tree(i).leaf_idx);
        end
         
        b1 = calculate_bias(vas.tree(i));
        if rem(epoch,500)==0 || epoch==1
            if epoch ==1
                acc(1)=find_acc(b1,i);
            else
        acc((epoch/500)+1)=find_acc(b1,i);
            end
        epoch
        end
%         b1=calculate_bias_upper_limit_adjusted(vas.tree(i),btarget);
        if epoch == vas.epoch
            saveb1(i,:) = b1;
        end
        %         saveb1(epoch,:,i) = b1;
        db1 = btarget-b1;
        %         [db1,adamm,adamv] = adam_trial( adam.mb1,adam.vb1,db1,1,vas.ln,1 );
        %         adam.mb1(:,1) = adamm;
        %         adam.vb1(:,1) = adamv;
        del_energy = calculate_delta_energy(vas.tree(i), db1);
        st_dE(1,epoch)=sqrt(sum((del_energy).^2));
        vas.eta =get_exp_eta_step(epoch, vas.epoch, 0.2, 0.12, 10000);
        
        [vas.tree(i),dW] = vascular_weight_update(vas.tree(i), vas.tree(i).leaf_idx, del_energy, vas.eta);
        st_dW(1,epoch)=dW;
        
        %         if rem(epoch, vas.save_every) == 0
        %             fprintf('Epoch: %d\n', epoch)
        %         end
    end
    %     figure(1);plot(st_dE);title('DelE for k=16, root energy= 512');xlabel('Epochs');hold on;
    %     figure(2);plot(st_dW);title('DelW for k=16, root energy= 512');xlabel('Epochs');hold on;
    if st_dE(end)>0.001
        warning(['selE = ',num2str(st_dE(end)),'not converged for K = ',num2str(branching),' root energy= ',num2str(vas.energy_in)]);
    end
end
% hold off;
% cd C:\Users\Bhadra\Desktop\task_2\eta0.05
% str =  'overk_' + string(branching) + '_l_' + string(l) + '.mat';
% save(str,'savee1','saveb1');
% cd C:\Users\Bhadra\Desktop\task_2
end