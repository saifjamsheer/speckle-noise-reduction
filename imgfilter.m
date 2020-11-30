function [filtered] = imgfilter(image,fsize,type,params)
% imgfilter is a function that takes in an image file 
% and runs a specified noise-reduction filter across
% the image to output a filtered image.
%
%   Inputs   
%   image:      name of the image file
%               example: 'filename.jpg'
%   fsize:      side length of the square filter mask 
%               example: 3
%   type:       type of filter used for noise-reduction
%               example: 'median'
%   params:     additional parameter specific to certain 
%               filter types 
%               example: 10
%
%   Outputs   
%   filtered:   matrix of pixel intensity values post
%               noise-reduction
%
%   Filter Types   
%   linear:     mean, gaussian, sharpening, unsharp 
%               masking, alpha-trimmed mean
%   non-linear: median, adaptive weighted mean,
%               truncated median, morphological
%               reconstruction, kuwahara
%           
%   Parameters
%   gaussian:   sigma - standard deviation of the guassian 
%               function
%   unsharp:    k - constant between 0 and 1 
%   trimmed:    alpha - integer between 1 and fsize^2
%   adaptive:   c - scaling constant (10 or 20 is ideal)
%   

% Read the image specified by the filename into a matrix
unfiltered = imread(image);

% Apply the selected filter to the unfiltered image
switch type
    
    case 'mean'
        % Apply a mean filter
        filtered = fmean(unfiltered,fsize);
            
    case 'gaussian'
        % Apply a gaussian filter
        filtered = fgaussian(unfiltered,params);
        
    case 'sharpening'
        % Apply a sharpening filter
        filtered = fsharpen(unfiltered,fsize);
    
    case 'unsharp masking'
        % Apply an unsharp masking filter
        filtered = funsharp(unfiltered,fsize,params);
    
    case 'alpha-trimmed mean'
        % Apply an alpha-trimmed mean filter
        filtered = ftrimmed(unfiltered,fsize,params);
    
    case 'median'
        % Apply a standard median filter
        filtered = fmedian(unfiltered,fsize);
           
    case 'adaptive weighted median'
        % Apply an adaptive weighted-median filter
        filtered = fadaptive(unfiltered,fsize,params);
        
    case 'truncated median'
        % Apply a truncated median filter
        filtered = ftruncated(unfiltered,fsize);
        
    case 'morphological reconstruction'
        % Apply morphological reconstruction
        filtered = fmorph(unfiltered,fsize);
        
    case 'kuwahara'
        % Apply a kuwahara filter
        filtered = fkuwahara(unfiltered,fsize);

end

% Apply a canny edge detector to the filtered image
edges = edge(unfiltered,'canny');

% Side-by-side comparison of the filtered and
% edge-detected images
combined = imshowpair(unfiltered, edges, 'montage');

end

