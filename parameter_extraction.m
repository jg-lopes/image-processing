function parameters = parameter_extraction(image)
    
    % Values of N analysed in the visu_contour file
    BW = imbinarize(image);
    B = bwboundaries(BW);
    z=B{1}(:,1)+1i*B{1}(:,2);
    coeff = dfdir(z, 10);
    
    % Module of the coeff
    z = abs(coeff);
    size(z);
    
    % Region props
    %stats = regionprops(BW, 'all');
    stats = regionprops(BW, 'Circularity', 'Eccentricity', 'EulerNumber', 'Extent', 'Solidity'); 
    
    %4*pi * surface * perimetre
    
    
    %filtered_stats = stats;
    % Difficult to encode data, wouldn't give the scalar values that might
    % be useful for pca
    %filtered_stats = rmfield(stats, {'SubarrayIdx', 'ConvexHull','ConvexImage','ConvexHull','ConvexImage','Image','FilledImage','PixelIdxList','PixelList'});
    % Multidimensional data that might be useful for PCA, but would require
    % further dimensional treatment
    %filtered_stats = rmfield(filtered_stats, {'Centroid', 'BoundingBox', 'Extrema', 'MaxFeretCoordinates', 'MinFeretCoordinates'});
    cell = struct2cell(stats);
    %cell;
    
    parameters = z';
    %parameters = [];
    for k = 1:length(cell)
        cell{k} = cell{k}(:);
        
        for i = 1:length(cell{k})
            parameters = [parameters cell{k}(i)];
        end
    end
    
    size(parameters);
    
end