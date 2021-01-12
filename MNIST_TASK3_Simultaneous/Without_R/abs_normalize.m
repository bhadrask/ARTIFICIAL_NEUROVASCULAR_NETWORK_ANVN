function tree_Weight = abs_normalize(tree_Weight)
tree_Weight(tree_Weight<0)=1e-10;
tree_Weight=bsxfun(@rdivide, tree_Weight,sum(abs(tree_Weight),1));
tree_Weight(isnan(tree_Weight))=0;
end