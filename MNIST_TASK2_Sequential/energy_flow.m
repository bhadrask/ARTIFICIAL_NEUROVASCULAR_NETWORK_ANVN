function tree = energy_flow(tree, energy_in)
    split_prev = zeros(size(tree.Energy));
    split_prev(1) = energy_in;
    Energy_temp = split_prev;
    for i = 1:tree.Nlevel 
       split = tree.Weight*split_prev;
       split_prev = split;
       tree.Energy = Energy_temp + split;
       Energy_temp = tree.Energy;
    end
end
