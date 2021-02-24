function [b_energy] = calculate_bias_parallel(Tree_Energy, Tree_leaf_idx)
   b_energy = 1-(Tree_Energy(Tree_leaf_idx));
   b_energy(b_energy<-1) = -1;
end