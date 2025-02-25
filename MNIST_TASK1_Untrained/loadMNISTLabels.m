function labels = loadMNISTLabels(filename)
	% loadMNISTLabels 
	% labels = loadMNISTLabels(filename)
	%
	% This function returns a [number of MNIST images]x1 matrix containing
	% the labels for the MNIST images
	%
	% INPUT:
	% 	- filename: Name of the label file
	% OUTPUT:
	%	- labels: Label vector

	fp = fopen(filename, 'rb');
	assert(fp ~= -1, ['Could not open ', filename, '']);

	magic = fread(fp, 1, 'int32', 0, 'ieee-be');
	assert(magic == 2049, ['Bad magic number in ', filename, '']);

	numLabels = fread(fp, 1, 'int32', 0, 'ieee-be');
	labels = fread(fp, inf, 'unsigned char');

	assert(size(labels,1) == numLabels, 'Mismatch in label count');
	fclose(fp);

end
