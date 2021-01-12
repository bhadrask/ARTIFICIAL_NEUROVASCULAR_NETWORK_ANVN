function b1 = bias_from_weights(tree, emax, i)
        b1 = 1 - tree(i).Energy(tree(i).leaf_idx)/emax;
        b1(b1 < -1) = -1;
        b1 = b1';
end