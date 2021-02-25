clear; close all;clc;
load('newdata1train_20kepoch.mat');
level=vas.tree.Level;
W1=sum(vas.tree.Weight,2);
% B1=mlp.b1;
Lmax=max(level);

load('newdata2train_20kepoch.mat');
W2=sum(vas.tree.Weight,2);
% B2=mlp.b1;
diffW=abs(W1-W2);
% diffbeta=abs(B1-B2);
for i=1:Lmax
    Wdifflevel=diffW(level==i);
    figure(i);subplot 211;stem(Wdifflevel);axis tight;title(['Difference between the weights of Dataset 1 & 2']);
    xlabel('Weight Difference at the level considered'); ylabel('Magnitude of Weight');
    subplot 212; plot(W1(level==i));axis tight;hold on; plot(W2(level==i));legend('w1','w2');title(['Distribution of Weights at the level ',num2str(i),' RMSE: ',num2str(sqrt(mean((Wdifflevel).^2)))]);
    xlabel('Weight Distribution at the level considered'); ylabel('Magnitude of Weight');
    VRMSE(i)=sqrt(mean((Wdifflevel).^2));
    clear Wdifflevel   
end
figure;plot(VRMSE); title('RMSE of the vascular weights at each level')
