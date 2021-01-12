function matrix = weight_abs_norm(matrix)
	% weight_abs_norm
	% matrix = weight_abs_norm(matrix)
	% 
	% This function absolute normalises the 
	% neural weight W1
	% 
	% INPUT:
	%  	- matrix: Matrix to be normalised
	% OUTPUT:
	% 	- matrix: Normalized matrix

    matrix = matrix./sum(abs(matrix),2);
    matrix(isnan(matrix))=0;
end