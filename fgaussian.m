function [filtered] = fgaussian(image,sigma)
% fgaussian is a function that performs gaussian filtering 
% of the inputted image in two dimensions. Each output
% pixel contains the sum of the elements within the  
% convolved window (essentially passing through a low-pass
% Gaussian filter).
%
%   Inputs   
%   image:      matrix of pixel intensity values
%   sigma:      standard deviation of the guassian function
%
%   Outputs   
%   filtered:   matrix of pixel intensity values post
%               noise-reduction
%

% Calculate the filter size based on the standard
% deviation of the gaussian function
fsize = 2*floor(3*sigma) + 1;

% Calculate the required image padding based on the
% filter size to initialize the filtered image
padding = (fsize - 1)/2;

% Pad the boundaries of the input image
padded = padarray(image, [padding, padding], 'symmetric'); 

% Create a zero matrix based on the size of the padded
% image
filtered = zeros(size(padded));

% Get the dimensions of the padded image
[rows, cols] = size(padded);

% Set the start and end positions of the image that the
% filter will iterate through
rstart = padding + 1;
rend = rows - padding;
cstart = padding + 1;
cend = cols - padding;

% Calculate the position of the center pixel of the 
% filter mask
center = (fsize+1)/2;

% Create a zero matrix based on the filter size to
% initialize a distance matrix
d = zeros(fsize);

% Iterate across the rows and columns of the filter
for k = 1:fsize
    for l = 1:fsize
        % Calculate the distance of the matrix element
        % to the center of the matrix
        d(k,l) = sqrt((k-center)^2 + (l-center)^2);
    end
end

% Calculate the values of the gaussian kernel elements
kernel = exp(-(d.^2)./(2*sigma^2));

% Normalize the gaussian kernel
kernel = kernel/sum(kernel(:));
disp(kernel)

% Convolve the gaussian kernel across the image using a 
% sliding window approach
for i = rstart:rend
    for j = cstart:cend
        
        % Get the contents of the current window
        window = double(padded(i-padding:i+padding, j-padding:j+padding));
        
        % Convolve the window the gaussian kernel
        convolved = window.*kernel;
        
        % Set the the central pixel of the window to the
        % sum of the elements in the convolved window
        filtered(i,j) = sum(convolved(:));
        
    end
end

% Remove the padding from the image
filtered = filtered(rstart:rend, cstart:cend);

end
