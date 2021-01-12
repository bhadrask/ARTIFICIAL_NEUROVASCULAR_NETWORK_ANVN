function Energy_temp = energy_flow_parallel(tree_Weight, energy_in, tree_Energy, tree_Nlevel)
Split_prev=zeros(size(tree_Energy));
Split_prev(1)=energy_in;
Energy_temp=Split_prev;
for i=1:tree_Nlevel
   Split=tree_Weight*Split_prev;
   Split_prev=Split;
   tree_Energy=Energy_temp+Split;
   Energy_temp=tree_Energy;
end
end