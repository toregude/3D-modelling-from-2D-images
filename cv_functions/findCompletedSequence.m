function sequence = findCompletedSequence(cellArray, startNode)
    visited = false(size(cellArray));
    sequence = [];
    dfs(startNode);

    function dfs(node)
        visited(node) = true;
        sequence = [sequence, node];
        
        children = cellArray{node};
        for i = 1:numel(children)
            child = children(i);
            if ~visited(child)
                dfs(child);
            end
        end
    end
end
