function [ mlp ] = weightnorm( mlp)
mlp.W1 = bsxfun(@rdivide,mlp.W1,sum((abs(mlp.W1)),2));
% mlp.W2 = bsxfun(@rdivide,mlp.W2,sum((abs(mlp.W2)),2));
mlp.W1(isnan(mlp.W1))=0;
% mlp.W2(isnan(mlp.W2))=0;
end
