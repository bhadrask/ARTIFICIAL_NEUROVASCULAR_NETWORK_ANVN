clc;clear all;close all;
load('emnistdataset.mat')
images = emnistsave.images2;
labels = emnistsave.labels2;
strimages = [];
strlabels = [];
total_train_samples=5000;
noofimages = total_train_samples/10;
for i=0:9
    counter =1;
    saveimages = []; savelabels=[];
    for j=1:size(labels,1)        
        if (labels(j,1) == i) 
            saveimages(:,counter) = images(:,j);
            savelabels(counter,1) = labels(j,1);
            counter=counter+1;
        end
    end
    saveimages = saveimages(:,1:noofimages);
    savelabels = savelabels(1:noofimages,1);
%     saveimages = reshape(saveimages,784,10,10);
%     savelabels = reshape(savelabels,10,10);
    strimages = cat(2,strimages,saveimages);
    strlabels = cat(1,strlabels,savelabels);
end
save(['Emnist_Equal_TRAIN_',num2str(total_train_samples),'.mat'],'strimages','strlabels');
%% 
% load('train10.mat')
% figure(1);
% for i=1:10
%     subplot(2,5,i);
%     imagesc(reshape(saveimages(:,(i-1)*10+1),28,28));set(gca,'XTick',[], 'YTick', [])
% 
% end
% suptitle('MNIST Data used for training');
%%
mlp_test_images = emnistsave.testimages2;
mlp_test_labels = emnistsave.testlabels2;
strimages = [];
strlabels = [];
total_test_samples=2000;
noofimages = total_test_samples/10;
for i=0:9
    counter =1;
    testsaveimages = []; testsavelabels=[];
    for j=1:size(mlp_test_labels,1)        
        if (mlp_test_labels(j,1) == i) 
            testsaveimages(:,counter) = mlp_test_images(:,j);
            testsavelabels(counter,1) = mlp_test_labels(j,1);
            counter=counter+1;
        end
    end
    testsaveimages = testsaveimages(:,1:noofimages);
    testsavelabels = testsavelabels(1:noofimages,1);
%     testsaveimages = reshape(testsaveimages,784,10,10);
%     testsavelabels = reshape(testsavelabels,10,10);
    strimages = cat(2,strimages,testsaveimages);
    strlabels = cat(1,strlabels,testsavelabels);
end
% save('test200.mat','strimages','strlabels');
save(['Emnist_Equal_TEST_',num2str(total_test_samples),'.mat'],'strimages','strlabels');
%% 