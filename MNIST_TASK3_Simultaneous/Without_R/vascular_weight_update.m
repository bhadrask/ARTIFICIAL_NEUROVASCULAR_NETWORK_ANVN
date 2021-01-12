function [Tree_Weight] = vascular_weight_update(Tree_Weight, actv_leaf_idx, actv_leaf_level,eta,Tree_Ntot,Tree_A,Tree_Nlevel,Tree_beforeweight)
    % actv_leaf_idx = actv_leaf_idx + Tree.Ntot - length(Tree.leaf_idx);
    act_vec = zeros(Tree_Ntot,1);
    act_vec(actv_leaf_idx) = 1;

    act_level = zeros(Tree_Ntot,1);
    act_level(actv_leaf_idx) = actv_leaf_level;
    
    numchild = sum(Tree_A,1);
    numchild(numchild==0) = 1;

    for i = 1:Tree_Nlevel-1
        act_vec_nxt = Tree_A'*act_vec;
        n1 = find(act_vec ~= 0 ); %parent nodes
        n2 = find(act_vec_nxt ~= 0);  %children nodes
        temp = Tree_Weight(n1,n2); % taking the weights between them 
        temp(temp~=0) = 1;
        act_level_mat = temp.*repmat(act_level(n1),1,numel(n2));
        Tree_Weight(n1,n2) = Tree_Weight(n1,n2)+ eta*act_level_mat;
        act_vec = act_vec_nxt; %parent becomes child
        act_level = (Tree_A'*act_level)./numchild';
    end
    delW = sqrt(sum(sum((Tree_Weight - Tree_beforeweight).^2)));
    Tree_beforeweight = Tree_Weight;
    Tree_Weight = abs_normalize(Tree_Weight);
    
end