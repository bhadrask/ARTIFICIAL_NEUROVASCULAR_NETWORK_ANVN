clc;clear all;close all;
load('emnist-letters.mat');

emnist.labels2_total = dataset.train.labels';
emnist.images2_total = im2double(dataset.train.images)';

emnist.test_images2_total = im2double(dataset.test.images)';
emnist.test_labels2_total = dataset.test.labels';

set2n=1;
for n=1:size(emnist.labels2_total,2)
    if emnist.labels2_total(1,n)<=10
        emnistsave.images2(:,set2n) = (emnist.images2_total(:,n));
        emnistsave.labels2(set2n,1) = emnist.labels2_total(1,n)-1;
        set2n = set2n + 1;
    end
end
set2n=1;
for n=1:size(emnist.test_labels2_total,2)
    if emnist.test_labels2_total(1,n)<=10
        emnistsave.testimages2(:,set2n) = emnist.test_images2_total(:,n);
        emnistsave.testlabels2(set2n,1) = emnist.test_labels2_total(1,n)-1;
        set2n = set2n + 1;
    end
end

save('emnistdataset.mat','emnistsave');