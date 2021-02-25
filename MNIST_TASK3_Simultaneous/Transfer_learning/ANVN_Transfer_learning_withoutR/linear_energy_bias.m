function value = linear_energy_bias(vector,factor)
    value = 1-(vector/factor);
    value(value<0) = 0;
end
% factor - a factor of maximum input at the root node,fixed forever...
% vector- energy at leaf nodes