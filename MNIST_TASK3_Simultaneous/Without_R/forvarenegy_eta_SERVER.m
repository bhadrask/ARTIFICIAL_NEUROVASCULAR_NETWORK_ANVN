function forvarenegy_eta_SERVER(trials,vas_ln, k, vas_dim, energy_in, vas_trials, mlp_train_images, ...
                         mlp_train_labels, mlp_test_images, mlp_test_labels, mlp_epoch, ...
                         mlp_save_every, mlp_eta_max, mlp_eta_min, mlp_train_size, mlp_test_size)

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
%         factor_e = 0.1;
       

%         energy_in =vas_energy_mat;
        [tree_Ntot, tree_Weight, tree_Energy, tree_A, tree_Nlevel, tree_leaf_idx,Tree_beforeweight] = define_tree(vas_ln, k, vas_dim, energy_in(j));

%         fprintf('Energy: %d \n', energy_in(j));

        for i = 1:mlp_epoch
            % Vascular forward prop
            fprintf('Epoch: %d Energy from Root: %d \n', i, energy_in(j));
            tree_Energy = energy_flow_parallel(tree_Weight, energy_in(j), tree_Energy, tree_Nlevel);

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
%             ma=max(db1)
%             mi=min(db1)
            % deldW2(1,i) = sqrt(sum(sum(dW2.^2)));

            % get the eta based on exp decay
            factor = 8000;
            eta = get_exp_eta(i, mlp_epoch, mlp_eta_max, mlp_eta_min, factor);

            % Update using eta, adams
            mlp_W2 = mlp_W2 - eta*dW2;
            mlp_W1 = mlp_W1 - eta*dW1;
            mlp_b2 = mlp_b2 - eta*db2;

            del_energy = calculate_delta_energy_parallel(tree_Energy, tree_leaf_idx, db1,vas_ln);
%             str_dele(1,i) = sqrt(sum(del_energy.^2));

            % Normalization of weights
            mlp_W1 = weightnorm(mlp_W1);

            % Update Vascular weights
            eta1 = get_exp_vas_eta(i, mlp_epoch, 0.02, 0.001);
            [tree_Weight] = vascular_weight_update(tree_Weight, tree_leaf_idx, del_energy, eta1, tree_Ntot, ...
                tree_A, tree_Nlevel, Tree_beforeweight);     
     
            
            if rem(i,mlp_save_every) == 0
                [~, idx] = max(a2);                
                mlp_train_success(1,i/mlp_save_every) = 100*sum(idx' == mlp_train_labels+1)/mlp_train_size;

                % Check testing
                t1 = mlp_test_images;
                t2 = sigmf(mlp_W1*t1 - repmat(mlp_b1,1, mlp_test_size), [mlp_c1, 0]);
                t3 = sigmf(mlp_W2*t2 - repmat(mlp_b2,1, mlp_test_size), [1, 0]);
                
                [~, tidx] = max(t3);
                mlp_test_success(1, i/mlp_save_every) = 100*sum(tidx' == mlp_test_labels + 1)/mlp_test_size;                
            end

        end
         tree_Energy_save = energy_flow_parallel(tree_Weight, energy_in(j), tree_Energy, tree_Nlevel);

        parsave_SERVER(trials,vas_ln, mlp_train_success, mlp_test_success,k,energy_in(j),mlp_W1,mlp_W2,mlp_b1,mlp_b2,tree_Energy_save);%, str_dele, wallowable_int,ENDsave_energy,init_energy);
    end
end