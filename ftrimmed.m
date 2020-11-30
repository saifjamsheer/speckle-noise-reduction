function [filtered] = ftrimmed(image,fsize,alpha)
% ftrimmed is a function that performs alpha-trimmed 
% mean filtering of the inputted image in two dimensions. 
% The output pixel is determined by calculating the 
% mean of a sorted list trimmed based on the value
% of alpha.
%
%   Inputs   
%   image:      matrix of pixel intensity values
%   fsize:      side length of the square filter mask 
%   alpha:      integer between 1 and (fsize^2 - 1) that
%               determines the size of the truncated
%               list
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

% Perform trimmed-mean filtering on the image using a 
% sliding window approach
for i = rstart:rend
    for j = cstart:cend
        
        % Get the contents of the current window
        window = double(padded(i-padding:i+padding, j-padding:j+padding));
        
        % Convert the window into a vector and sort the
        % elements in ascending order
        wsorted = sort(transpose(window(:)));
        
        % Slice list to create the alpha-trimmed list
        trimmed = wsorted(alpha+1:end-alpha);
        
        % Calculate the mean of the trimmed list
        m = sum(trimmed)/(N - 2*alpha);
        
        % Set the central pixel of the window
        % to the mean
        filtered(i,j) = m;
        
    end
end

% Remove the padding from the image
filtered = filtered(rstart:rend, cstart:cend);

end

