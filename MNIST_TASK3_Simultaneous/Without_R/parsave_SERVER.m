function parsave_SERVER(trials,vas_ln,mlp_train_success,mlp_test_success,k,energy_in,mlp_W1,mlp_W2,mlp_b1,mlp_b2,tree_Energy_save)

    cd C:\Users\Bhadra\Documents\GitHub\ANVN_FINAL\MNIST_TASK3_Simultaneous\Without_R\task3_data

    str =  'k_' + string(k)+'_energy_' + string(energy_in)+'_Trial_'+num2str(trials)+'.mat';
    save(str, 'vas_ln','mlp_train_success','mlp_test_success','mlp_W1','mlp_W2','mlp_b1','mlp_b2','tree_Energy_save')
     cd C:\Users\Bhadra\Documents\GitHub\ANVN_FINAL\MNIST_TASK3_Simultaneous\Without_R
end
