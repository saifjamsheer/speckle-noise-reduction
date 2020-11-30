function [filtered] = fkuwahara(image,fsize)
% fkuwahara is a function that performs kuwahara filtering 
% of the inputted image in two dimensions. Each output
% pixel contains the mean value of the square region in the
% fsize x fsize window that is most homogeneous. 
%
%   Inputs   
%   image:      matrix of pixel intensity values
%   fsize:      side length of the square filter mask 
%
%   Outputs   
%   filtered:   matrix of pixel intensity values post
%               noise-reduction
%

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

% Perform kuwahara filtering on the image using a
% sliding window approach
for i = rstart:rend
    for j = cstart:cend
        
        % Get the contents of the current window
        window = double(padded(i-padding:i+padding, j-padding:j+padding));
        
        % Divide the window into four square regions where
        % a is the top left region, b the top right, c the
        % bottom left, and d the bottom right
        a = window(1:padding+1,1:padding+1);
        b = window(1:padding+1,padding+1:fsize);
        c = window(padding+1:fsize,1:padding+1);
        d = window(padding+1:fsize,padding+1:fsize);
        
        % Calculate the standard deviation and mean of each
        % of the four square regions
        s = std([a(:), b(:), c(:), d(:)]);
        m = mean([a(:), b(:), c(:), d(:)]);
        
        % Determine the index of the square region with the
        % lowest standard deviation
        [~,ind] = min(s);
        
        % Set the central pixel of the window to the mean
        % of the region with the lowest standard deviation
        filtered(i,j) = m(ind);
        
    end
end

% Remove the padding from the image
filtered = filtered(rstart:rend, cstart:cend);

end

