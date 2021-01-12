function tree = assign_equal_weights(tree)
	% assign_equal_weights
	% tree = assign_equal_weights(tree)
	%
	% This function distributes vascular weights 
	% in scuh a way that all the root nodes 
	% receive equal energy
	% 
	% INPUT:
	% 	- tree: Vascular tree structure
	% OUTPUT:
	% 	- tree: Vascular tree structure with 
	%			weight distibution that ensures
	%			equal leaf node energy
	
    proportion = sum(tree.A);
    proportion = proportion.*floor((tree.k).^(tree.Nlevel-1-tree.Level));
    proportion(tree.leaf_idx) = 1;
    tree.child_idx = tree.A.*repmat([1:tree.Ntot]',1,tree.Ntot);
    tree.equal_weights = zeros(size(tree.A));
    for i = 1:(tree.Ntot-length(tree.leaf_idx))
        tree.equal_weights(tree.A(:,i) ~= 0, i) = proportion(tree.child_idx(:,i) ~= 0)';
    end
    tree = abs_normalize(tree);
end