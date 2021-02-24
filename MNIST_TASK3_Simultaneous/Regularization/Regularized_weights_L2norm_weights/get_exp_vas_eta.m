function eta = get_exp_vas_eta(epoch, max_epoch, maximum, minimum)
    factor = 10000;
%     eta = minimum + (maximum - minimum)*exp(-epoch/(factor));
    if epoch < factor
        eta = minimum + (maximum - minimum)*exp(-epoch/(factor));
    else
        eta = minimum;
    end
end