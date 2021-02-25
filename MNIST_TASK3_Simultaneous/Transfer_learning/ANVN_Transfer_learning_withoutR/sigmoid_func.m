function val = sigmoid_func(X)
    % X - matrix of dimensions = n*m
    % where m would be the total number of samples
    % and each column would denote the 28*28 matrix
    
    val = 1./(1+exp(-X));
end
