function [filtered] = ftruncated(image,fsize)
% ftruncated is a function that performs truncated median 
% filtering of the inputted image in two dimensions. 
% Sets the output pixel to the median of a truncated list
% of pixels from the fsize x fsize window, which approximates
% the mode of the distribution.
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

% Perform truncated median filtering on the image using a 
% sliding window approach
for i = rstart:rend
    for j = cstart:cend
        
        % Get the contents of the current window
        window = double(padded(i-padding:i+padding, j-padding:j+padding));
        
        % Convert the window into a vector and sort the
        % elements in ascending order
        untruncated = sort(transpose(window(:)));
        
        % Determine the minimum, maximum, and median
        % values of the sorted vector
        umin = untruncated(1);
        umax = untruncated(end);
        umed = untruncated((N+1)/2);
        
        % Calculate the distance of the median from
        % the maximum and minimum
        dlow = umed - umin;
        dhigh = umax - umed;
        
        % Median is closer to the minimum
        if dhigh > dlow
            
            % Iterate through the untruncated list
            for k = 1:length(untruncated)
                
                % Execute when the value of the element
                % in the untruncated list is greater than
                % the sum of the median and the distance
                % from the median to the minimum
                if untruncated(k) > umed + dlow
                     tdex = k-1;
                     % Create the truncated list
                     truncated = untruncated(1:tdex);
                     break
                end
            end
            
            % Determine the median of the truncated list
            median = truncated(floor((length(truncated)+1)/2));
        
        % Median is closer to the maximum
        elseif dlow > dhigh
            
            % Iterate backwards through the untruncated list
            for k = length(untruncated):-1:1
                
                % Execute when the value of the element
                % in the untruncated list is greater than
                % the difference between the median and the 
                % distance from the median to the maximum
                if untruncated(k) < umed - dhigh
                     tdex = k+1;
                     % Create the truncated list
                     truncated = untruncated(tdex:end);
                     break
                end
            end
            
            % Determine the median of the truncated list
            median = truncated(floor((length(truncated)+1)/2));
            
        else
            
            % Set the median to the median of the untruncated
            % list
            median = umed;
            
        end
        
        % Set the central pixel of the window
        % to the selected median
        filtered(i,j) = median;
        
    end
end

% Remove the padding from the image
filtered = filtered(rstart:rend, cstart:cend);

end
