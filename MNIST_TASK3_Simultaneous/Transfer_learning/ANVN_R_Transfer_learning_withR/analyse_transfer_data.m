clear; close all; clc;
Ln=100;
k=8;
[tree_Ntot, tree_Nlevel, tree_Level, tree_last_node, tree_leaf_idx]  = Initialize(Ln,k); % Initialize tree in terms of nodes, levels
    
load('D:\github_desktop\Vascular_Tree\Transfer_learning_simultaneous_withR\Mnist_first_0Lam\ln_100_wallow_0.02.mat');
D1percapita=sum(END_energy)/numel(END_energy);

% load('TL_DATA1_MNIST_EMNIST.mat');
level=tree_Level;
W1=sum(tree_Weight,2);
wallow_trained1=sum(END_energy)/5000
B1=mlp_b1;
Lmax=max(level);
   figure(1);
   plot(END_energy); hold on;
   figure(2);
   plot(mlp_train_success); hold on;
   D1_TEST_ACC=mlp_test_success(end)
   D1_TRAIN_ACC=mlp_train_success(end)
   clear END_energy;
load('D:\github_desktop\Vascular_Tree\Transfer_learning_simultaneous_withR\EMnist_second_0Lam\ln_100_wallow_0.02.mat');
wallow_trained2=sum(END_energy)/5000
figure(2);
   plot(mlp_train_success);legend('Trained on MNIST','Transferred to EMNIST')
D2percapita=sum(END_energy)/numel(END_energy)
   D2_TEST_ACC=mlp_test_success(end)
   D2_TRAIN_ACC=mlp_train_success(end)
% load('TL_DATA2_MNIST_EMNIST.mat');
W2=sum(tree_Weight,2);
B2=mlp_b1;
diffW=abs(W1-W2);
diffbeta=abs(B1-B2);
  figure(1);
   plot(END_energy); hold off;
   diffW(1)=abs(wallow_trained2-wallow_trained1);
for i=1:Lmax
    Wdifflevel=diffW(level==i);
%      figure(i);subplot 211;stem(Wdifflevel);title(sum(abs(Wdifflevel)));
%      subplot 212; plot(W1(level==i));hold on; plot(W2(level==i));legend('w1','w2');
 VRMSE2(i)=sqrt(sum(Wdifflevel).^2);
     clear Wdifflevel

end
figure;plot(VRMSE2); xlabel('Levels'); ylabel('RMSE of vsc weights');title('RMSE of vasc weights (EMNIST-MNIST)');
figure;stem((diffW));title('RMSE vasc, full node')
figure;plot(diffbeta);title('Difference in bias of neurons');


for jk=[100,1000,5000,20000]%:10000:mlp_epoch
for i=1:Lmax
VRMSE2(i)=VRMSE(jk,i);

end
figure(5);plot(VRMSE2); xlabel('Levels'); ylabel('RMSE of vasc weights');title('RMSE of vasc weights (EMNIST-MNIST)');
ylim([0,1.5]);hold on; pause(1);
end


for i=1:4
     strlabel(1,i) = 'Level ' + string(i);
figure(6);plot(VRMSE(:,i));xlabel('Epochs'); ylabel('RMSE between U_A and U_B across levels');hold on;
end
figure(6);legend(strlabel);
title({'RMSE between U_A and U_B across epochs','at each vascular level'})
