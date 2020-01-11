function parameters = image_parameter_extraction(image)
    
    % Values of N analysed in the visu_contour file
    BW = imbinarize(image);
    B = bwboundaries(BW);
    z=B{1}(:,1)+1i*B{1}(:,2);
    coeff = dfdir(z, 10);
    
    % Module of the coeff
    z = abs(coeff);
    size(z);
    
    % Uncovering other interesting proprieties from the images using
    % regionprops
    
    % First we take proprieties from the image that will be applied
    % directly to the classification algorithm 
    direct_props = regionprops(BW, 'Circularity', 'Eccentricity', 'EulerNumber', 'Extent', 'Solidity'); 
    cell = struct2cell(direct_props);
    
    % Then, measures which will be indirectly placed in the algorithm
    indirect_props = regionprops(BW, 'Area', 'Perimeter');
    surr_per_ratio = 4 * pi * indirect_props.Area / indirect_props.Perimeter^2;
    cell{end+1} = surr_per_ratio;
    
    
    parameters = z';
    for k = 1:length(cell)
        cell{k} = cell{k}(:);
        
        for i = 1:length(cell{k})
            parameters = [parameters cell{k}(i)];
        end
    end
    
end