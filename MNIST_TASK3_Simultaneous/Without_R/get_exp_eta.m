function eta = get_exp_eta(epoch, max_epoch, maximum, minimum, factor)
    if epoch < factor
        eta = minimum + (maximum - minimum)*exp(-epoch/(factor));
    else
        eta = minimum;
    end
end