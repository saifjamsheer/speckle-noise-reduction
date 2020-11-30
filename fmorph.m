function [filtered] = fmorph(image,fsize)
% fmorph is a function that performs morphological 
% reconstruction of the inputted image in two dimensions. 
% This operates by processing a marker image based on
% the characteristics of the mask image (input image)
% until the output pixel values of the marker image
% stop changing. Erosion is used to create the marker
% and iterative dilation results in the final filtered
% image.
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
mask = padarray(image, [padding, padding], 'symmetric'); 

% Create a zero matrix based on the size of the padded
% image
marker = zeros(size(mask));

% Get the dimensions of the padded image
[rows, cols] = size(mask);

% Set the start and end positions of the image that the
% filter will iterate through
rstart = padding + 1;
rend = rows - padding;
cstart = padding + 1;
cend = cols - padding;

% Perform erosion on the image using a sliding window
% approach to create the marker
for i = rstart:rend
    for j = cstart:cend
        
        % Get the contents of the current window
        window = double(mask(i-padding:i+padding, j-padding:j+padding));
        
        % Convert the window into a vector and sort the
        % elements in ascending order
        wsorted = sort(transpose(window(:)));
        
        % Set the central pixel of the window to
        % the lowest value in the sorted vector
        marker(i,j) = wsorted(1);
    end
end

mask = double(mask);
J = imreconstruct(marker,mask);

% Create a zero matrix based on the size of the marker
% to initialize the dilated image
dilated = zeros(size(marker));

% Set initial stability to false
stability = false;

% Iterative dilation until stability is achieved
while not(stability)
    
    % Storing the pixel values of the previous dilated 
    % marker
    previous = marker;
    
    % Perform dilation on the image using a sliding
    % window approach
    for i = rstart:rend
        for j = cstart:cend
            
            % Get the contents of the current window
            window = double(marker(i-padding:i+padding, j-padding:j+padding));
            
            % Convert the window into a vector and sort the
            % elements in ascending order
            wsorted = sort(transpose(window(:)));
            
            % Limit the maximum value of the pixel of the
            % filtered image to the respective pixel on
            % the mask
            peak = min(wsorted(end), mask(i,j));
            
            % Set the central pixel of the window to 
            % the above value
            dilated(i,j) = peak;
        end
    end
    
    % Determine if stability is reached
    stability = isequal(previous,dilated);
    
    % Set the marker to the current dilated pixels
    marker = dilated;
    
end

% Remove the padding from the image
filtered = dilated(rstart:rend, cstart:cend);

end
