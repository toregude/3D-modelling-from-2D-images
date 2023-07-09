function [G, matches] = find_match_graph(features, valid, imageFiles)
    adjacency_matrix = zeros(size(imageFiles,1));
    matches = cell(size(imageFiles,1),size(imageFiles,1));

    for i = 1:size(imageFiles,1)
        for j = i+1:size(imageFiles,1)
            feature1 = features{i};
            feature2 = features{j};
            [indexPairs,matchMetric] = matchFeatures(feature1.Features,feature2.Features);
            val1 = valid{i};
            val2 = valid{j};
            matchedPoints1 = val1.Location(indexPairs(:,1),:);
            matchedPoints2 = val2.Location(indexPairs(:,2),:);
            if and(length(matchedPoints1)>5, length(matchedPoints2)>5)
                %Add possible link between images
                adjacency_matrix(i,j) = 1;
                matches{i,j} = matchedPoints1;
                matches{j,i} = matchedPoints2;
            end
        end
    end

    G = graph(adjacency_matrix, "upper");
end