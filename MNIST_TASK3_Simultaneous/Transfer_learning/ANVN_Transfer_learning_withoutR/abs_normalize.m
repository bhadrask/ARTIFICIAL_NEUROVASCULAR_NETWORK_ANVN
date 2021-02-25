function Tree = abs_normalize(Tree)
Tree.Weight(Tree.Weight<0)=1e-10;
Tree.Weight=bsxfun(@rdivide, Tree.Weight,sum(abs(Tree.Weight),1));
Tree.Weight(isnan(Tree.Weight))=0;