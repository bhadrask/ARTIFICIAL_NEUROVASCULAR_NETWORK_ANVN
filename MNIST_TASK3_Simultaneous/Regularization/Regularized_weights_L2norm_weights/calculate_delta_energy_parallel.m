function [d_energy] = calculate_delta_energy_parallel(tree_Energy,tree_leaf_idx,db,vas_ln)

    negative_fb = zeros(size(tree_Energy(tree_leaf_idx)));
    negative_fb(tree_Energy(tree_leaf_idx)>2) = -0.005;%-0.001;%-0.008;%(9*10^-3)*exp((1*10^-5)*vas_ln );
    
    slope = -1*ones(size(tree_Energy(tree_leaf_idx)));
    slope(tree_Energy(tree_leaf_idx)>2) = 0;
    
    d_energy = -slope.*db;
    % enr = max(abs(d_energy))
    d_energy = d_energy + negative_fb;
    % fb = max(abs(negative_fb))
end