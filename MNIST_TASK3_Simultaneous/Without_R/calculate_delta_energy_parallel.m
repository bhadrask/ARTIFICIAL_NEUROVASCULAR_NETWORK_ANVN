function [d_energy] = calculate_delta_energy_parallel(tree_Energy,tree_leaf_idx,db,vas_ln)
    slope = -1*ones(size(tree_Energy(tree_leaf_idx)));
    
    negative_fb=zeros(size(tree_Energy(tree_leaf_idx)));
    negative_fb(tree_Energy(tree_leaf_idx)>2)=-0.02;%(9*10^-3)*exp((1*10^-5)*vas_ln );%9*10^-5*vas_ln;
    
%     slope(tree_Energy(tree_leaf_idx)>2) = 0;
%     slope(tree_Energy(tree_leaf_idx)<=2) = -1;
    
    d_energy = -slope.*db;
    d_energy=d_energy + negative_fb;
    
end