 function [Acc] = find_acc(bin,trials)   
 load('F:\Github_team\ANVN_FINAL\MNIST_MLP_training\MNIST_mlp_Train_500_test_200_epochs_20000.mat')
           mlp.test_size = test_size;
        mlp.train_size = train_size;
% [test.test_images, test.test_labels, mlp.X1, mlp.labels]=load_mnist(mlp.test_size);
          test.test_images=test_images; 
     test.test_labels=test_labels;
     mlp.X1=images;
     mlp.labels=labels;

     
        mlp.c1 =5; mlp.c2=0;
for i = trials:trials
     
            
            b1 =bin;
            
            z1 = opt.W1*test.test_images - repmat(b1,1,size(test.test_images,2));
            a1 = sigmf(z1, [mlp.c1, mlp.c2]);
            
            z2 = opt.W2*a1 - repmat(opt.b2,1,size(a1,2));
            a2 = sigmf(z2, [1, 0]);
            
            [~, label] = max(a2);
            accuracy = 100*sum(label' == test.test_labels+1)/mlp.test_size;
            %         fprintf('Difference (energy: %d) = %d\n', energy_in, norm(opt.b1-b1(:,i)));
            Acc = accuracy;
        end