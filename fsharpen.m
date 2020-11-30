function [filtered] = fsharpen(image,fsize)
% fsharpen is a function that performs sharpening filtering 
% of the inputted image in two dimensions. Each output pixel
% contains the sum of the elements within the convolved
% window to emphasize the edges.
%
%   Inputs   
%   image:      matrix of pixel intensity values
%   fsize:      side length of the square filter mask 
%
%   Outputs   
%   filtered:   matrix of pixel intensity values post
%               noise-reduction
%

% Number of elements in the filter
N = fsize^2;

% Calculate the required image padding based on the
% filter size
padding = (fsize - 1)/2;

% Pad the boundaries of the input image
padded = padarray(image, [padding, padding], 'symmetric'); 

% Create a zero matrix based on the size of the padded
% image to initialize the filtered image
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

% Initialize the sharpening mask with the required
% values
mask = -1*ones(fsize);

% Set the center of the sharpening mask to one
% less than the number of elements in the filter
mask(center,center) = N-1;

% Convolve the sharpening mask across the image using a 
% sliding window approach
for i = rstart:rend
    for j = cstart:cend
        
        % Get the contents of the current window
        window = double(padded(i-padding:i+padding, j-padding:j+padding));
        
        % Convolve the window with the sharpening mask
        convolved = window.*mask;
        
        % Set the the central pixel of the window to the
        % sum of the elements in the convolved window
        filtered(i,j) = sum(convolved(:))/N;
        
    end
end

% Remove the padding from the image
filtered = filtered(rstart:rend, cstart:cend);

end