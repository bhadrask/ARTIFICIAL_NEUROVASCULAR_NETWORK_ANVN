function [Tree] = define_tree(Ln,k,dim,Energy_In)%,Weightinitial)
Tree=Initialize(Ln,k); % Initialize tree in terms of nodes, levels
Ntot=Tree.Ntot;
last_node=Tree.last_node;
Level=Tree.Level;
%% Estimation of adjascency matrix
A=zeros(Ntot);
pstart=2;
for i=1:Ntot-Ln
    pend=pstart+k-1;    
    if pend>last_node(Level(i)+1);
        pend=last_node(Level(i)+1);
    end
    A(pstart:pend,i)=1;
    pstart=pend+1;    
end
% figure(1);imagesc(A);title('adjacency matrix');
%% Initialize weight matrix, position matrix and Energy matrix
Tree.Node_cords=rand(Ntot,dim);
Tree.Weight = rand(size(A)).*A;%cell2mat(Weightinitial);
Tree=abs_normalize(Tree);
Tree.Energy=[Energy_In;zeros(Ntot-1,1)];
Tree.A=A;
end