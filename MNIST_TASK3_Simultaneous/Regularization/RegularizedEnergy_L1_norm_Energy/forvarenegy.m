function forvarenegy(vas_ln, k, vas_dim, vas_energy_mat, vas_trials, mlp_train_images, mlp_train_labels, mlp_test_images, mlp_test_labels, mlp_epoch, mlp_save_every, mlp_eta_max, mlp_eta_min, mlp_train_size, mlp_test_size)
%     rng(rng_set);
    for j = 1:vas_trials
        mlp_m = size(mlp_train_images,2);
        mlp_n1 = size(mlp_train_images,1);
        mlp_n2 = vas_ln;
        mlp_n3 = length(unique([mlp_test_labels; mlp_train_labels]));
        mlp_num_labels = mlp_n3;
        mlp_c1 = 5;

        mlp_W1 = zeros(mlp_n2, mlp_n1);
        mlp_b1 = repmat(rand(mlp_n2,1), 1);
        mlp_W2 = zeros(mlp_n3, mlp_n2);
        mlp_b2 = repmat(rand(mlp_n3,1),1);
        mlp_train_success = zeros(1, mlp_epoch/mlp_save_every);
        mlp_test_success = zeros(1, mlp_epoch/mlp_save_every);

        mlp_id_mat = eye(mlp_num_labels);
        wallowable = 0.05; wstorage = 1-wallowable;

        energy_in = wallowable*vas_energy_mat(j);
        [tree_Ntot, tree_Weight, tree_Energy, tree_A, tree_Nlevel, tree_leaf_idx,Tree_beforeweight] = define_tree(vas_ln, k, vas_dim, energy_in);
        % tree_[] = Energy = [energy_in; zeros(Ntot-1,1)];

        
%         master_A=zeros(size(tree_A)+2);
%         master_A(2,1)=1;
%         master_A(3:end,3:end)=tree_A;
%         master_A(3,1)=1;
%         D = digraph(master_A');
%         figure;plot(D);
%         D1 = digraph(tree_A');
%         figure;plot(D1);
        fprintf('Energy: %d \n', vas_energy_mat(j));
        counter =0;flag =0; preva1 = zeros (mlp_n2,mlp_m);

        for i = 1:mlp_epoch
            % Vascular forward prop
            fprintf('Epoch: %d Energy from Root: %d \n', i, energy_in);
            tree_Energy = energy_flow_parallel(tree_Weight, energy_in, tree_Energy, tree_Nlevel);
            percap_energy_con(1, i/mlp_save_every) = sum(tree_Energy(tree_leaf_idx))/vas_ln;

            % Bias calculation
            mlp_b1 = calculate_bias_parallel(tree_Energy, tree_leaf_idx);

            % Neural forward prop
            z1 = mlp_W1*mlp_train_images - mlp_b1;
            a1 = sigmf(z1, [mlp_c1, 0]);       

            z2 = mlp_W2*a1 - mlp_b2;
            a2 = sigmf(z2, [1, 0]);

            % Neural weights, bias update
            delta3 = a2 - mlp_id_mat(:,mlp_train_labels+1);
            delta2 = (delta3.*a2.*(1-a2));
            delta1 = (mlp_W2'*delta2).*(mlp_c1.*a1.*(1-a1));

            dW2 = (delta2*a1')/mlp_m;
            dW1 = (delta1*mlp_train_images')/mlp_m;
            db2 = -sum(delta2, 2)/mlp_m;
            db1 = -sum(delta1, 2)/mlp_m;
            % deldW2(1,i) = sqrt(sum(sum(dW2.^2)));

            % get the eta based on exp decay
            factor = 5000;
            eta = get_exp_eta(i, mlp_epoch, mlp_eta_max, mlp_eta_min, factor);

            % Update using eta, adams
            mlp_W2 = mlp_W2 - eta*dW2;
            mlp_W1 = mlp_W1 - eta*dW1;
            mlp_b2 = mlp_b2 - eta*db2;

            del_energy = calculate_delta_energy_parallel(tree_Energy, tree_leaf_idx, db1);
            % str_dele(1,i) = sqrt(sum(del_energy.^2));

            % Normalization of weights
            mlp_W1 = weightnorm(mlp_W1);

            % Update Vascular weights
            eta1 = get_exp_vas_eta(i, mlp_epoch, 0.1, 0.01);
            [tree_Weight, wallowable] = vascular_weight_update(tree_Weight, wallowable, tree_leaf_idx, del_energy, eta1, tree_Ntot, ...
                tree_A, tree_Nlevel, Tree_beforeweight);     
            
            energy_in = wallowable*vas_energy_mat(j);

            if rem(i,mlp_save_every) == 0
                %                 fprintf('Epoch: %d; Eta: %f \n', i, eta);
                MSE_vector_train=sum((a2 - mlp_id_mat(:,mlp_train_labels+1)).^2);
                mse_train(1, i/mlp_save_every) = sum(MSE_vector_train)/mlp_train_size;
                [~, idx] = max(a2);                
                mlp_train_success(1,i/mlp_save_every) = 100*sum(idx' == mlp_train_labels+1)/mlp_train_size;

                % Check testing
%                 mlp_test_images = imnoise(mlp_test_images,'gaussian',0,0.0002);
                t1 = mlp_test_images;
                t2 = sigmf(mlp_W1*t1 - repmat(mlp_b1,1, mlp_test_size), [mlp_c1, 0]);
                t3 = sigmf(mlp_W2*t2 - repmat(mlp_b2,1, mlp_test_size), [1, 0]);
                 MSE_vector_test=sum((t3 - mlp_id_mat(:,mlp_test_labels+1)).^2);
                mse_test(1, i/mlp_save_every) = sum(MSE_vector_test)/mlp_test_size;
                [~, tidx] = max(t3);
                mlp_test_success(1, i/mlp_save_every) = 100*sum(tidx' == mlp_test_labels + 1)/mlp_test_size;                
            end
%             
%             if i == 500 % under
%                 under_testacc = mlp_test_success(i);
%                 under_trainacc = mlp_train_success(i);
%             end
%             if i > 500 && flag ==0 % opti
%                 dacctest = mlp_test_success(i) - mlp_test_success(i -1);
%                 if dacctest >=0
%                     contifactor = 100;
%                     if dacctest == 0 || counter>contifactor
%                         counter  =counter +1;
%                     end                    
%                     if counter>contifactor && dacctest > 0
%                         opt_testacc = mlp_test_success(i-1);
%                         opt_trainacc = mlp_train_success(i-1);
%                         opt_epoch = i;
%                         flag =1;
%                     end
% %                     if counter<contifactor && dacctest > 0
% %                         counter =0;
% %                     end
%                 else
%                     counter =0;
%                 end
%                 
%             end
%             if i == mlp_epoch % over
%                 over_testacc = mlp_test_success(i);
%                 over_trainacc = mlp_train_success(i);
%             end
%             if i == mlp_epoch - 1
%                 Edesirable = del_energy + tree_Energy(tree_leaf_idx);
%             end
%             if i == mlp_epoch
%                 Eavailable = tree_Energy(tree_leaf_idx);
%                 Edeficiency = Edesirable - Eavailable;
%             end
        end
    %     figure();plot(str_dele);
    %     figure();plot(delw);
    %     figure();plot(deldW2);
       
        figure();plot(percap_energy_con(1:mlp_epoch));title('Per capita energy consumption');xlabel('Epochs');
        
        figure();plot(mlp_train_success(1:mlp_epoch));hold on;
        plot(mlp_test_success(1:mlp_epoch));hold on;
        plot(100-mlp_train_success(1:mlp_epoch));hold on;
        plot(100-mlp_test_success(1:mlp_epoch));hold off;
        legend('Train success','Test Success','Train Error','Test Error');xlabel('Epochs');
        
        figure();plot(percap_energy_con(1:mlp_epoch),mlp_test_success(1:mlp_epoch));
        xlabel('Per Capita Energy Consumption');ylabel('Accuracy');
        
        figure();plot(mse_train(1:mlp_epoch));hold on;
        plot(mse_test(1:mlp_epoch));hold off;
         legend('Train MSE','Test MSE');xlabel('Epochs');
        
        accuracy_test = mlp_test_success;
        accuracy_train = mlp_train_success;
        par_save(vas_energy_mat(j), k,percap_energy_con,mlp_train_success,mlp_test_success,mse_train,mse_test);
%         par_save(energy_in, k, under_testacc, under_trainacc, opt_testacc, opt_trainacc, opt_epoch, over_testacc, over_trainacc);
    end
end