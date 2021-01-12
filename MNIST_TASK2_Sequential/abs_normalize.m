function tree = abs_normalize(tree)
    tree.Weight(tree.Weight<0) = 1e-10;
    tree.Weight  =bsxfun(@rdivide, tree.Weight,sum(abs(tree.Weight),1));
    tree.Weight(isnan(tree.Weight)) = 0;  
    
    if isfield(tree, 'equal_weights')
        tree.equal_weights(tree.equal_weights<0) = 1e-10;
        tree.equal_weights = bsxfun(@rdivide, tree.equal_weights,sum(abs(tree.equal_weights),1));
        tree.equal_weights(isnan(tree.equal_weights)) = 0;
    end
end

