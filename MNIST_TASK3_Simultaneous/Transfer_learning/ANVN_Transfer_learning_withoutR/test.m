% clc;clear all;close all;
load('newdata1train_20kepoch.mat')
weights_d1(:,1) = sum(vas.tree(1).Weight,2);
load('newdata2train_20kepoch.mat')
weights_d2(:,1) = sum(vas.tree(1).Weight,2);
for i=1:size(vas.tree(1).last_node,2)-1
    V1 = weights_d1(vas.tree(1).last_node(i)+1:vas.tree(1).last_node(i+1),1);
    V2 = weights_d2(vas.tree(1).last_node(i)+1:vas.tree(1).last_node(i+1),1);
    RMSE(i,1) = sqrt(mean((V1-V2).^2));
end
figure();plot(RMSE);
xlabel('Level in the tree'); ylabel('RMSE at each Level');
title('RMSE at each Level');

for i=1:size(vas.tree.last_node,2)-1
    figure();plot(weights_d1(vas.tree.last_node(i)+1:vas.tree.last_node(i+1),1));axis tight;hold on;
    plot(weights_d2(vas.tree.last_node(i)+1:vas.tree.last_node(i+1),1));axis tight;
    title(['Distribution of Weights at the level ',num2str(i)]);legend('Trained Weights for dataset D1','Trained Weights for dataset D2')
    xlabel('Weight Distribution at the level considered'); ylabel('Magnitude of Weight');
end
% 
% figure();plot(bias_d1);hold on;plot(bias_d2);axis tight;
% legend('Bias for dataset D1','Bias for dataset D2');
% xlabel('Leaf Nodes'); ylabel('Bias');

% RMSE_bias = sqrt(mean((bias_d1-bias_d2).^2));