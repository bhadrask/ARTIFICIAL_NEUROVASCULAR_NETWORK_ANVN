function tree = Initialize(N,k)
	% Initialize
	% tree = Initialize(N,k)
	% 
	% Initializes the vascular tree given
	% the number of leaf nodes
	% 
	% INPUT:
	% 	- N: Number of leaf nodes
	% 	- k: Order of branching in the vascular tree
	% OUTPUT:
	% 	- tree: Vascular tree structure with 
	%			Ntot, Level, last_node, leaf_idx, Nlevel
	%			fields

    lev = 1 + ceil(log(N)/log(k));
    Lgrp = k.^(0:lev-1);
    Nod_lev = (ceil(N./Lgrp));
    
    % Nod_lev=[N,Nod_lev];
    Nod_lev = sort(Nod_lev);
    Ntot = sum(Nod_lev);
    Level = zeros(1,Ntot);
    ix = 1;
    last_node = zeros(1,numel(Nod_lev));
   
    for i = 1:numel(Nod_lev)
        Level(ix:ix+Nod_lev(i)-1) = i;
        last_node(i) = ix + Nod_lev(i)-1;
        ix = ix + Nod_lev(i);
    end
    
    tree.Ntot = Ntot;
    tree.Level = Level;
    tree.last_node = last_node;
    tree.leaf_idx = (Ntot-N+1:Ntot)';
    tree.Nlevel = lev;
end
