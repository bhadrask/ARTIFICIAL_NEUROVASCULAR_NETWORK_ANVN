% Load results from Task 2
clc;
clear;
close all;

test_images = loadMNISTImages('t10k-images.idx3-ubyte');
test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');

test.test_images = test_images(:,1:500);
test.test_labels = test_labels(1:500);
test.test_size = numel(test.test_labels);

colorc = jet(65);

%% Testing
kk=16;%[16,256,512];
% vas_energy_mat = [1,100:100:600];
load('D:\github_desktop\Vascular_Tree\results\task1\512.mat')
for i=1:numel(kk)
    disp(['K=',num2str(i)]);
   Cvec=0;
    for rep=1:1    
        str = 'D:\github_desktop\Vascular_Tree\task_2\trials\opti_k_' + string(kk(i)) + '_trial_'+  string(rep)+ '.mat';
%         cd 'data'
        load(str)
%         cd ..
        vas_energy_mat = sum(savee1,2);
        hid_nod = size(W1,1);
        for rt_no=1:numel(vas_energy_mat)
             disp(['root energy=',num2str(vas_energy_mat(rt_no)),' trial number=',num2str(rep)]);
            b1=saveb1(rt_no,:);
            error_vec = zeros(hid_nod, 1);
            
            for j = 1:hid_nod
                test.t2 = sigmf(W1*test.test_images - b1', [5,0]);
                test.t2(j,:) = 0;
                test.t3 = sigmf(W2*test.t2 - b2, [1, 0]);
                [~, test.idx] = max(test.t3);
                
                error_vec(j) = sum(test.idx' ~= test.test_labels+1)/test.test_size;
            end
            
            
            Energy = savee1(rt_no,:);
             Energy(Energy>2)=2;
            R = corrcoef(Energy,error_vec);
            corval=R(1,2);
            Corrloop(rt_no) = corval;
             efficiency(rt_no)=accuracy_test/sum(Energy);
%             figure();
%            subplot 211; plot(Energy)
% 
%             subplot 212;plot(error_vec)
%               figure(i);  subplot(6,3,rt_no);scatter(Energy,error_vec);hold on;
%                 xlabel('Energy of each leaf node');
%                 ylabel('Error');
            %     title(['For Energy ' num2str(vas_energy_mat(1,rt_no)) ' Correlation ' num2str(R(1,2)) ]);
        end
        Cvec=Cvec+Corrloop;
        correlation_vec(i,:)=Cvec;
    end
    correlation_vec(i,:)= correlation_vec(i,:)/rep;
    figure(1);
    plot(vas_energy_mat,correlation_vec(i,:),'color',colorc(20*i,:));hold on;
    xlabel('Root Node Energy');
    ylabel('Correlation between the Test Error and Leaf Energy');
    title('Plot of Root Node Energy vs Correlation between the Test Error and Leaf Energy ');

end
% hold off;
% legend('k = 16','k = 256','k = 512') 