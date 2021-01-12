function eta = get_exp_eta(epoch, maxepoch, maximum, minimum, fact)
    if epoch < fact
        eta = minimum + (maximum - minimum)*exp(-epoch/(fact/2));
    else
        eta = minimum;
    end
end