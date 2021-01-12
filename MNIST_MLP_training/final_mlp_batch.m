% function [test_images, test_labels, images, labels, success, test_success, W1, W2, b1, b2, rng_set] = batch(ln, 
    % MLP batch algorithm
    % Assuming only one hidden layer
    %
    % n1 - input layer size
    % n2 - second layer
    % n3 - output layer size
clear;close all;
clc;

rng('default');
eta_max = 0.3;
eta_min = 0.05;
epoch = 20000;
ln = 512;
test_size = 200;
train_size = 500;
flag = 0;
c1 = 5;
c2 = 0;
factor = 10000;  
save_every = 10;

labels = loadMNISTLabels('train-labels.idx1-ubyte');
images = loadMNISTImages('train-images.idx3-ubyte');

test_images = loadMNISTImages('t10k-images.idx3-ubyte');
test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');

% Randomly permute the train and test images and labels.
train_perm = randperm(train_size);
images = images(:, train_perm);
labels = labels(train_perm);

test_perm = randperm(test_size);
test_images = test_images(:, test_perm);
test_labels = test_labels(test_perm);

% Take only samples of size train_size and test_size
images = images(:, 1:train_size);
labels = labels(1:train_size);

test_images = test_images(:,1:test_size);
test_labels = test_labels(1:test_size);

% Initialize important parameters
m = size(images,2);
n1 = size(images,1);
n2 = ln;
n3 = 10; %length(unique([test_labels; labels]));
id_mat = eye(n3);

rng('default');
W1 = zeros(n2, n1);
b1 = rand(n2,1);
W2 = zeros(n3,n2);
b2 = rand(n3,1);

success = zeros(ceil(epoch/save_every),1);
test_success = zeros(ceil(epoch/save_every),1);
flag = 0;counter = 0;

% Start training
for i = 1:epoch
    % Forward pass
    z1 = W1*images - b1;
    a1 = sigmf(z1, [c1, c2]);

    z2 = W2*a1 - b2;
    a2 = sigmf(z2, [1, 0]);

    % Backward pass
    % delta3 = a2 - id_mat(:, labels(bval:eval)+1);
    delta3 = a2 - id_mat(:, labels+1);
    delta2 = (delta3.*a2.*(1-a2));
    delta1 = (W2'*delta2).*(c1.*a1.*(1-a1));

    dW2 = (delta2*a1')/m;
    dW1 = (delta1*images')/m;
    db2 = -sum(delta2, 2)/m;
    db1 = -sum(delta1, 2)/m;

    % get eta based on epoch
    eta = get_exp_eta(i, epoch, eta_max, eta_min, factor);
    % eta = get_step_eta(i);

    W2 = W2 - eta*dW2;
    W1 = W1 - eta*dW1;
    b2 = b2 - eta*db2;
    b1 = b1 - eta*db1;

    W1 = weight_abs_norm(W1);

    if rem(i, save_every) == 0
        fprintf('Epoch: %d; eta: %f \n', i, eta);  
        [~, idx] = max(a2);
        success(i/save_every) = sum(idx' == labels+1)/train_size;

        % Testing
        t1 = test_images;  
        t2 = sigmf(W1* t1 - b1, [c1,c2]);
        t3 = sigmf(W2*t2 - b2, [1,0]);  
        [~, idx] = max(t3);  
        test_success(i/save_every) = sum(idx' == test_labels + 1)/test_size;
               
%         if i == 500 %under
%             ut.W1 = W1;
%             ut.W2 = W2;
%             ut.b1 = b1;
%             ut.b2 = b2;
%         end
%         if (i >= 5000) && (flag == 0) && (test_success(i/save_every)-test_success(i/save_every-1)>=0) % optimal
%             if (test_success(i/save_every)-test_success(i/save_every-1)==0) || counter >50
%                 counter = counter +1;
%             end
%             if (test_success(i/save_every)-test_success(i/save_every-1)>=0) && counter >50
%                 opt.W1 = W1;
%                 opt.W2 = W2;
%                 opt.b1 = b1;
%                 opt.b2 = b2;
%                 opt.epoch = i;
%                 flag = 1;
%             end
%         end
%         if (i >= 5000) && (test_success(i/save_every)-test_success(i/save_every-1)<0)  && (flag == 0)
%             counter = 0;
%         end
        
        if (i>5000) && (i == epoch) % over
            opt.W1 = W1;
            opt.W2 = W2;
            opt.b1 = b1;
            opt.b2 = b2;
        end
        
    end
end
figure();
tit1 = 'Accuracy vs Epochs, eta_max: ' + string(eta_max);
plot(1:save_every:epoch, 100*success);hold on;
plot(1:save_every:epoch, 100*test_success)
plot(1:save_every:epoch, 100*(1-success))
plot(1:save_every:epoch, 100*(1-test_success))
hold off;
legend('Train accuracy', 'Test accuracy', 'Train loss', 'Test loss', 'Location', 'best')
xlabel('Epoch Number')
ylabel('Accuracy')
title(tit1)

figure();
plot(1:save_every:epoch, 100*(success-(test_success)));
xlabel('Epoch Number')
ylabel('Difference between the Test Error and train Error');
title('For three training conditions');

accuracy_train = success(end)*100;
fprintf('Train Accuracy : %f\n', accuracy_train);

accuracy_test = test_success(end)*100;
fprintf('Test Accuracy : %f\n', accuracy_test);



str = strcat('MNIST_mlp_Train_',num2str(train_size),'_test_',num2str(test_size),'_epochs_',num2str(epoch),'.mat');
save(str)
