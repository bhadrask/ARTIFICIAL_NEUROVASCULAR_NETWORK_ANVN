function [test_images, test_labels, images, labels] = load_mnist(test_size)

   labels = loadMNISTLabels('train-labels.idx1-ubyte');
    images = loadMNISTImages('train-images.idx3-ubyte');

    test_images = loadMNISTImages('t10k-images.idx3-ubyte');
    test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');

    test_tot = size(test_images,2);


  

    test_perm = randperm(test_tot);
    test_images = test_images(:, test_perm);
    test_labels = test_labels(test_perm);


    test_images = test_images(:,1:test_size);
    test_labels = test_labels(1:test_size);
