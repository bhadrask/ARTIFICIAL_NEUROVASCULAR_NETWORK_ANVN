function parsave_SERVER(trials,vas_ln,mlp_train_success,mlp_test_success,k,energy_in,mlp_W1,mlp_W2,mlp_b1,mlp_b2,tree_Energy_save)

    cd F:\Github_team\Vascular_Tree\task_3_without_reservoir\for_plotting_journal\2021

    str =  'k_' + string(k)+'_energy_' + string(energy_in)+'_Trial_'+num2str(trials)+'.mat';
    save(str, 'vas_ln','mlp_train_success','mlp_test_success','mlp_W1','mlp_W2','mlp_b1','mlp_b2','tree_Energy_save')
     cd F:\Github_team\Vascular_Tree\task_3_without_reservoir
end
