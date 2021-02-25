function [Tree_Ntot, Tree_Nlevel, Tree_Level, Tree_last_node, Tree_leaf_idx] = Initialize(N,k)
    lev=1+ceil(log(N)/log(k));
    Lgrp=k.^(0:lev-1);
    Nod_lev=(ceil(N./Lgrp));
    % Nod_lev=[N,Nod_lev];
    Nod_lev=sort(Nod_lev);
    Ntot=sum(Nod_lev);
    Level=zeros(1,Ntot);
    ix=1;
    last_node=zeros(1,numel(Nod_lev));
    for i=1:numel(Nod_lev)
        Level(ix:ix+Nod_lev(i)-1)=i;
        last_node(i)=ix+Nod_lev(i)-1;
        ix=ix+Nod_lev(i);
    end
    Tree_Ntot=Ntot;
    Tree_Level=Level;
    Tree_last_node=last_node;
    Tree_leaf_idx=(Ntot-N+1:Ntot)';
    Tree_Nlevel=lev;
end