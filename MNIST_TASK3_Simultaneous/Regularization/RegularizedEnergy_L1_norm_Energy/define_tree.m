function [Ntot, tree_Weight, tree_Energy, tree_A, tree_Nlevel, tree_leaf_idx, Tree_beforeweight] = define_tree(Ln,k,dim,Energy_In,rng_set)%,Weightinitial)
    [tree_Ntot, tree_Nlevel, tree_Level, tree_last_node, tree_leaf_idx]  = Initialize(Ln,k); % Initialize tree in terms of nodes, levels
    
    rng(rng_set);
    Ntot = tree_Ntot;
    last_node = tree_last_node;
    Level = tree_Level;
    %% Estimation of adjascency matrix
    A = zeros(Ntot);
    W = zeros(Ntot);
    Count=numel(find(Level==max(Level)-1));
    pstart = 2;
    for i =  1:Ntot-Ln
        pend = pstart+k-1;    
        if pend>last_node(Level(i)+1)
            pend = last_node(Level(i)+1);
        end
        W(pstart:pend,i) = 1/(pend-pstart+1);
        if i>(Ntot-(Ln+Count))
            W(pstart:pend,i) = rand(pend-pstart+1,1);
        end
          A(pstart:pend,i)=1;
        pstart = pend+1;
    end
    
    childnodes=sum(A,1);
    childnodes(tree_leaf_idx)=1;
    W=W.*childnodes';
    % figure(1);imagesc(A);title('adjacency matrix');
    %% Initialize weight matrix, position matrix and Energy matrix
    %     tree_Node_cords = rand(Ntot,dim);
%     a = 0.4;
%     b = 0.7;
%     r = (b-a).*rand(size(A)) + a;
    tree_Weight = W;%cell2mat(Weightinitial);
    tree_Weight = abs_normalize(tree_Weight);
    Tree_beforeweight = tree_Weight;
    tree_Energy = [Energy_In;zeros(Ntot-1,1)];
    tree_A = A;

end