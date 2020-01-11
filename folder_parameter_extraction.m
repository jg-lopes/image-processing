function [X, Y] = folder_parameter_extraction (folder_name, type_image_base)
    % Folder_name = Folder that 
    %
    %
    
    % Iterating and extracting features
    liste=dir(fullfile(folder_name,['*.' type_image_base]));

    for n=1:length(liste)
        nom=liste(n).name;
        image=double(imread(fullfile(folder_name,nom)))/255;
        fid=fopen(fullfile(folder_name,[nom(1:strfind(nom,'.')-1) '.txt']),'r');
        classe=fscanf(fid,'%d');
        fclose (fid);

        parameters = image_parameter_extraction(image);

        % If first iteration, prealocate the X and Y vectors for optimization
        if n == 1
           X = zeros(length(liste), length(parameters));
           Y = zeros(length(liste), 1);
        end

        X(n, :) = parameters;
        Y(n) = classe;
    end


end