function [b_energy] = calculate_bias(Tree)
   b_energy = 1-(Tree.Energy(Tree.leaf_idx));
   b_energy(b_energy<-1) = -1;
end