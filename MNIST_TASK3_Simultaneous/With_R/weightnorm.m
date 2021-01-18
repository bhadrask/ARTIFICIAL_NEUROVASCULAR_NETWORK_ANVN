function [ mlp_W1 ] = weightnorm( mlp_W1)
mlp_W1 = bsxfun(@rdivide,mlp_W1,sum((abs(mlp_W1)),2));
% mlp.W2 = bsxfun(@rdivide,mlp.W2,sum((abs(mlp.W2)),2));
mlp_W1(isnan(mlp_W1))=0;
% mlp.W2(isnan(mlp.W2))=0;
end
