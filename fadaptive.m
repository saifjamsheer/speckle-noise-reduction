function [filtered] = fadaptive(image,fsize,c)
% fadaptive is a function that performs adaptive weighted 
% median filtering of the inputted image in two dimensions. 
% Each output pixel contains the median value in a weighted 
% fsize x fsize window, based on the distance of each term
% to the centre of the window, within the input image.
%
%   Inputs   
%   image:      matrix of pixel intensity values
%   fsize:      side length of the square filter mask 
%   c:          scaling constant
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

% Create a zero matrix based on the filter size to
% initialize a distance matrix
d = zeros(fsize);

% Create a zero matrix based on the filter size to
% initialize a weight matrix
weights = zeros(fsize);

% Calculate the position of the center pixel of the 
% filter mask
center = (fsize+1)/2; 

% Value of the central (maximum) weight for the 
% window
wc = 100;

% Perform adaptive weighted median filtering on the image 
% using a sliding window approach
for i = rstart:rend
    for j = cstart:cend
        
        % Get the contents of the current window
        window = double(padded(i-padding:i+padding, j-padding:j+padding));
        
        % Calculate the mean and standard deviation
        % of the elements in the window
        wmean = sum(window(:))/(N);
        wstd = std(transpose(window(:)));
        
        % Setting the mean to 1 to avoid dividing
        % by zero
        if wmean == 0; wmean = 1; end 
        
        % Iterate across the rows and columns of the filter
        % to set the weight values for each window pixel
        for k = 1:fsize
            for l = 1:fsize
                % Calculate current value of the distance
                % matrix
                d(k,l) = sqrt((k-center)^2 + (l-center)^2);
                % Calculate the weight for the current
                % pixel
                weights(k,l) = wc - c*d(k,l)*wstd/wmean;
                % Set negative weights to zero for low-pass
                % functionality of the filter
                if weights(k,l) < 0; weights(k,l) = 0; end
            end
        end
        
        % Create a two-row matrix with the first row equal
        % to the contents of the window and the second equal
        % to their respective weights
        ww(1,:) = transpose(window(:));
        ww(2,:) = transpose(weights(:));
        
        % Sort the contents of the window based on their
        % pixel intensity values (ascending order)
        wsorted = sortrows(ww.', 1).';
        
        % Initialize a sum to determine the position of
        % the median
        wsum = 0;
        
        % Determine the sum that signifies the position
        % of the median
        msum = floor(sum(abs(ww(2,:)))/2);
        
        % Initialize a counter value for the loop
        count = 1;
        
        % Find the position of the median
        while wsum < msum
            
            % Sum weights from initial to current
            % position
            wsum = wsum + wsorted(2,count);
            
            % Increase the counter value
            count = count+1;
            
        end
        
        % Determine the median of the sorted window
        median = wsorted(1, count-1);
        
        % Set the central pixel of the window
        % to the median
        filtered(i,j) = median;
        
    end
end

% Remove the padding from the image
filtered = filtered(rstart:rend, cstart:cend);

end
