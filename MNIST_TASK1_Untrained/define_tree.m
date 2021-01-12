function tree = define_tree(ln,k,dim,energy_in)
	% define_tree
    % tree = define_tree(ln,k,dim,energy_in)
    %
	% This function defines the vascular 
	% tree structue
    % 
	% INPUT:
	% 	- ln: Number of vascular leaf nodes
	% 	- k: Order of branching of the vascular tree
	% 	- dim: Dimension of the coordinate space in which
	%		   the nodes are placed
	%	- energy_in: Initial root node energy
	% OUTPUT:
	% 	- tree: Vascular tree structure

    tree = Initialize(ln,k); % Initialize tree in terms of nodes, levels
    Ntot = tree.Ntot;
    last_node = tree.last_node;
    Level = tree.Level;
    %% Estimation of adjascency matrix
    A = zeros(Ntot);
    pstart = 2;
    for i = 1:Ntot-ln
        pend = pstart+k-1;
    
        if pend > last_node(Level(i)+1)
            pend = last_node(Level(i)+1);
        end
        
        A(pstart:pend,i)=1;
        pstart=pend+1;    
    end
    % figure(1);imagesc(A);title('adjacency matrix');
    %% Initialize weight matrix, position matrix and Energy matrix
    tree.Node_cords = rand(Ntot,dim);
    tree.Weight = rand(size(A)).*A;
    tree = abs_normalize(tree);
    tree.Energy = [energy_in; zeros(Ntot-1,1)];
    tree.A = A;
    tree.k = k;
end
