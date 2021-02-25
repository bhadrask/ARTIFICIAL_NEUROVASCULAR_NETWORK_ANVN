function [new_b2,diffb2,indx2] = energy_check(b2,Tree)
    % b2 which is the mlp demanded bias update can be >= b_energy, energy allowed bias
    % bias, aka threshold needs more energy to have smaller values

    b_energy = 1-(Tree.Energy(Tree.leaf_idx));
    b_energy(b_energy<-1)=-1;
    diffb = b_energy-b2;
    indx2 = find(diffb~=0);
    diffb2 = diffb(indx2);

    indx = find(diffb>0);
    new_b2 = b2;
    new_b2(indx) = b_energy(indx);
end