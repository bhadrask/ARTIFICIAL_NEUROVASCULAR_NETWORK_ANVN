clear; close all;clc;
load('Feb2021_E500_DATA1_MNIST_EMNIST.mat');

D1percapita=sum(vas.tree.Energy(vas.tree.leaf_idx))/numel(vas.tree.Energy(vas.tree.leaf_idx))
acc1=mlp.test_success/size(mlp.test_images1,2);
% load('TL_DATA1_MNIST_EMNIST.mat');
level=vas.tree.Level;
W1=sum(vas.tree.Weight,2);
B1=mlp.b1;
Lmax=max(level);
   figure(1);
   plot(vas.tree.Energy(vas.tree.leaf_idx)); hold on;

   D1_TEST_ACC=accuracy_test
   D1_TRAIN_ACC=accuracy_train
load('Feb2021_TL7_E500_DATA2_MNIST_EMNIST.mat');
acc2=mlp.test_success/size(mlp.test_images2,2);
D2percapita=sum(vas.tree.Energy(vas.tree.leaf_idx))/numel(vas.tree.Energy(vas.tree.leaf_idx))
   D2_TEST_ACC=accuracy_test
   D2_TRAIN_ACC=accuracy_train
% load('TL_DATA2_MNIST_EMNIST.mat');
W2=sum(vas.tree.Weight,2);
B2=mlp.b1;
diffW=abs(W1-W2);
diffbeta=abs(B1-B2);
  figure(1);
   plot(vas.tree.Energy(vas.tree.leaf_idx)); hold off;
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


for jk=[100,1000,5000,20000]%:10000:mlp.epoch
for i=1:Lmax
VRMSE2(i)=VRMSE(jk,i);

end
figure(5);plot(VRMSE2); xlabel('Levels'); ylabel('RMSE of vsc weights');title('RMSE of vasc weights (EMNIST-MNIST)');
ylim([0,1.5]);hold on; pause(1);
end


for i=2:7
     strlabel(1,i-1) = 'Level number ' + string(i);
figure(6);plot(VRMSE(:,i)); hold on;
end
figure(6);legend(strlabel);
