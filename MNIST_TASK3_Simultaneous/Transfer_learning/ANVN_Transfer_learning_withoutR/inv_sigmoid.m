function value = inv_sigmoid(vector,c1,c2)
    value = 1-(sigmf(vector,[c1,c2]));
end