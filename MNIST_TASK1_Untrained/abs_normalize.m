function tree = abs_normalize(tree)
	% abs_normalize 
    % tree = abs_normalize(tree)
    %
    % This function normalizes the vascular tree
    % weights at each level.
    %
	% INPUT:
	% 	- tree - vascular tree structure
	% OUTPUT:
	% 	- tree - vascular tree structure with normalized weights
	
    tree.Weight(tree.Weight<0) = 0;
    tree.Weight = bsxfun(@rdivide, tree.Weight,sum(abs(tree.Weight),1));
    tree.Weight(isnan(tree.Weight)) = 0;  
    
    if isfield(tree, 'equal_weights')
        tree.equal_weights(tree.equal_weights<0) = 0;
        tree.equal_weights = bsxfun(@rdivide, tree.equal_weights,sum(abs(tree.equal_weights),1));
        tree.equal_weights(isnan(tree.equal_weights)) = 0;
    end
end

