function Tree = energy_flow(Tree,energy_in)
Split_prev=zeros(size(Tree.Energy));
Split_prev(1)=energy_in;
Energy_temp=Split_prev;
for i=1:Tree.Nlevel
 
   Split=Tree.Weight*Split_prev;
   Split_prev=Split;
   Tree.Energy=Energy_temp+Split;
   Energy_temp=Tree.Energy;
end
end