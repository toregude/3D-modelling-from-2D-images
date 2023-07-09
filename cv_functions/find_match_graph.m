function matches = find_match_graph(features, valid, imageFiles)
    matches = cell(size(imageFiles,1),size(imageFiles,1));
    for i = 1:size(imageFiles,1)
        for j = i+1:size(imageFiles,1)
            feature1 = features{i};
            feature2 = features{j};
            indexPairs = matchFeatures(feature1.Features,feature2.Features);
            val1 = valid{i};
            val2 = valid{j};
            matchedPoints1 = val1.Location(indexPairs(:,1),:);
            matchedPoints2 = val2.Location(indexPairs(:,2),:);
            if and(length(matchedPoints1)>5, length(matchedPoints2)>5)
                matches{i,j} = matchedPoints1;
                matches{j,i} = matchedPoints2;
            end
        end
    end
end