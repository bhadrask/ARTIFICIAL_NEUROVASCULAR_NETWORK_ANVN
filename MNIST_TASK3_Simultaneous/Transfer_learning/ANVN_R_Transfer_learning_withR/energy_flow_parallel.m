function energy_temp = energy_flow_parallel(tree_weight, energy_in, tree_energy, tree_n_level)
split_prev = zeros(size(tree_energy));
split_prev(1) = energy_in;
energy_temp = split_prev;
	for i = 1:tree_n_level
	   split = tree_weight*split_prev;
	   split_prev = split;
	   energy_temp = energy_temp + split;
	end
end