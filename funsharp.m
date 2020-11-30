function [filtered] = funsharp(image,fsize,k)
% funsharp is a function that performs unsharp masking  
% of the inputted image in two dimensions. Each output
% pixel contains a value between the orginal value and  
% the mean value of the elements in in an fsize x fsize  
% window within the input image.
%
%   Inputs   
%   image:      matrix of pixel intensity values
%   fsize:      side length of the square filter mask 
%   k:          constant between 0 and 1      
%
%   Outputs   
%   filtered:   matrix of pixel intensity values post
%               noise-reduction
%

% Number of elements in the filter
N = fsize^2;

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

% Perform unsharp masking on the image using a
% sliding window approach
for i = rstart:rend
    for j = cstart:cend
        
        % Get the contents of the current window
        window = double(padded(i-padding:i+padding, j-padding:j+padding));
        
        % Calculate the mean of the window
        m = sum(window(:))/N;
        
        % Set the central pixel of the window
        % to the scaled mean
        filtered(i,j) = m + k*(filtered(i,j)-m); 
        
    end
end

% Remove the padding from the image
filtered = filtered(rstart:rend, cstart:cend);

end

