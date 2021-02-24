 load('w2_noreg.mat')
plot([10,30:20:90,150:50:500],A(:,1));ylim([0,2]);
hold on;
clear;
load('w2_0.5lam.mat')
plot([16,24,32,42,52,64,72,80,96,100:25:450],A(:,1));ylim([0,2]);
hold on;
clear
load('w2_5lam.mat')

plot([16,24,32,42,52,64,72,80,96,100:25:450],A(:,1));ylim([0,2]);
legend('no regularization','lambda=0.5','lambda=5');
xlabel('number of hidden neurons');
ylabel('per capita consumption during low energy initialization');