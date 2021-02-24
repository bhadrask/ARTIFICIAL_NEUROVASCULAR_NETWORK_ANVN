function parsave_2(Big_weight,vas_ln, percap_energy_con, mlp_train_success, mlp_test_success, dele, wallowable,END_energy,init_energy,tree_W_init,mlp_W1,mlp_W2,mlp_b1,mlp_b2,tree_Weight)
    cd C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\Transfer_learning_simultaneous_withR\Mnist_first_detailed_0Lam

    str =  'ln_' + string(vas_ln) + '_wallow_' + string(wallowable)+ '.mat';
    save(str, 'Big_weight','percap_energy_con','mlp_train_success','mlp_test_success','dele', 'vas_ln','END_energy','init_energy','tree_W_init','mlp_W1','mlp_W2','mlp_b1','mlp_b2','tree_Weight')
     cd C:\Users\Bhadra\Documents\GitHub\Vascular_Tree\Transfer_learning_simultaneous_withR
end
