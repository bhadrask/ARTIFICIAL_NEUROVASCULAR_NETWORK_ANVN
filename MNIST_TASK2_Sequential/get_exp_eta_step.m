function eta = get_exp_eta_step(epoch, max_epoch, maximum, minimum, factor)
    if epoch < factor
        eta = minimum + (maximum - minimum)*exp(-epoch/(factor/2));
    else
        eta = minimum;
    end
end