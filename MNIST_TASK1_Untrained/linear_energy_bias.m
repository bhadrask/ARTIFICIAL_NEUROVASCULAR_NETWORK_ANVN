function bias = linear_energy_bias(energy, Emax, bias_trained)
	% linear_energy_bias
	% bias = linear_energy_bias(energy, Emax, bias_trained)
	%
	% This is the linear energy bias function that maps
	% the vascular energy to the biases.
	%
	% INPUT:
    % 	- Emax: X-axis intercept of the 
    % 	- vector: energy at leaf nodes
    % OUTPUT:
    %	- bias: Bias vector

    bias = bias_trained;
    bias_energy = 1-(energy/Emax);
%     indx = bias_trained - bias_energy;
%     bias(indx < 0) = bias_energy(indx<0);
 bias=bias_energy;
    bias(bias < -1) = -1;
end


