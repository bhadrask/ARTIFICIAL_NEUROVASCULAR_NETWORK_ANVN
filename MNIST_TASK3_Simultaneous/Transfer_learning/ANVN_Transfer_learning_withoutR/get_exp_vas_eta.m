function eta = get_exp_vas_eta(epoch,maximum, minimum,factor)
   
%     eta = minimum + (maximum - minimum)*exp(-epoch/(factor));
    if epoch < factor
        eta = minimum + (maximum - minimum)*exp(-epoch/(factor));
    else
        eta = minimum;
    end
end