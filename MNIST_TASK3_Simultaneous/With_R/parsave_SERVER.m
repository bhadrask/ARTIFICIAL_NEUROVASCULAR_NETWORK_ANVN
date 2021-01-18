function parsave_SERVER(vas_ln,percap_energy_con,mlp_train_success,mlp_test_success,dele, wallowable,END_energy,init_energy,deldW1,deldW2,trial,tree_W_init,mlp_w1,mlp_w2,mlp_b1,mlp_b2)
    cd D:\github_desktop\ANVN_FINAL\MNIST_TASK3_Simultaneous\With_R\check
    c = clock;
    str1 = string(c(3)) + '_' + string(c(2)) + '_' + string(c(4)) + '_' +string(c(5));
%     str = 'wallowable'+string(wallowable) + '.mat';
    str =  'ln_' + string(vas_ln) + '_wallow_' + string(wallowable)+ '_trial_' + string(trial)+ '.mat';
    save(str, 'percap_energy_con','mlp_train_success','mlp_test_success','dele', 'vas_ln','END_energy','init_energy','deldW1','deldW2','tree_W_init','mlp_w1','mlp_w2','mlp_b1','mlp_b2')
     cd D:\github_desktop\ANVN_FINAL\MNIST_TASK3_Simultaneous\With_R
end
