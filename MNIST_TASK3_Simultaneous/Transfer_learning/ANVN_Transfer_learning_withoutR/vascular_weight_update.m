function Tree = vascular_weight_update(Tree, actv_leaf_idx, actv_leaf_level,eta)
    % actv_leaf_idx = actv_leaf_idx + Tree.Ntot - length(Tree.leaf_idx);
    act_vec = zeros(Tree.Ntot,1);
    act_vec(actv_leaf_idx) = 1;

    act_level = zeros(Tree.Ntot,1);
    act_level(actv_leaf_idx) = actv_leaf_level;
    
    numchild = sum(Tree.A,1);
    numchild(numchild==0) = 1;
    for i = 1:Tree.Nlevel
        act_vec_nxt = Tree.A'*act_vec;
        n1 = find(act_vec ~= 0 ); %parent nodes
        n2 = find(act_vec_nxt ~= 0);  %children nodes
        temp = Tree.Weight(n1,n2); % taking the weights between them 
        temp(temp~=0) = 1;
        act_level_mat = temp.*repmat(act_level(n1),1,numel(n2));
        Tree.Weight(n1,n2) = Tree.Weight(n1,n2)+ eta*act_level_mat;
        act_vec = act_vec_nxt; %parent becomes child
        act_level = (Tree.A'*act_level)./numchild';
    end
    
    Tree = abs_normalize(Tree);
end