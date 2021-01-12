function tree = energy_flow_equal(tree)
	% energy_flow
	% tree = energy_flow_equal(tree)
	% 
	% Generates the Energy flow based on the equal 
	% energy distribution weights in the vascular tree
	%
	% INPUT:
	% 	- tree: Vascular tree structure
	% OUTPUT:
	% 	- tree: Vascular tree structure with 
	%			the Energy distribution

	split_prev = tree.Energy;
	for i = 1:tree.Nlevel
	    DD = tree.Energy;
	    % split = tree.Weight*split_prev;
	    split = tree.equal_weights*split_prev;
	    split_prev = split;
	    tree.Energy = DD + split;
	end
end