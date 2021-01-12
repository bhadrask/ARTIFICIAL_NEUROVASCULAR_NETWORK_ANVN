function [d_energy] = calculate_delta_energy(tree, db)
    slope = tree.Energy(tree.leaf_idx);
    slope(tree.Energy(tree.leaf_idx)>2) = 0;
    slope(tree.Energy(tree.leaf_idx)<=2) = -1;
    d_energy = slope.*db;
end