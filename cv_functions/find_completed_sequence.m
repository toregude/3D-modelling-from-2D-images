function sortedIndices = find_completed_sequence(tree)
    the_graph = zeros(length(tree));
    for i = 1:length(tree)

        connections = tree{i};
        n = length(connections);

        for j = 1:n
            k = connections(j);
            the_graph(i,k) = 1;

        end
    end

    numNodes = size(the_graph, 1);
    visited = zeros(1, numNodes);
    path = zeros(1, numNodes);
    
    % Start DFS from the first node
    dfs(1, 1);
    
end

function dfs(node, index)
    visited(node) = 1;
    path(index) = node;
    
    % Find unvisited neighbors of the current node
    neighbors = find(the_graph(node, :));
    unvisitedNeighbors = neighbors(~visited(neighbors));
    
    if isempty(unvisitedNeighbors)
        % All nodes have been visited, path found
        path = path(1:index);
        return;
    end
    
    % Explore unvisited neighbors recursively
    for i = 1:numel(unvisitedNeighbors)
        nextNode = unvisitedNeighbors(i);
        dfs(nextNode, index+1);
        
        % If path found, exit the loop and return
        if path(numNodes) ~= 0
            return;
        end
    end
    
    % Backtrack if path not found
    visited(node) = 0;
    path(index) = 0;
end