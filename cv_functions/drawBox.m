
function drawBox(origin, sideLengths)
    % Extract coordinates of the origin
    x = origin(1);
    y = origin(2);
    z = origin(3);
    
    % Extract side lengths
    sideLengthX = sideLengths(1);
    sideLengthY = sideLengths(2);
    sideLengthZ = sideLengths(3);
    
    % Define the vertices of the box
    vertices = [
        x, y, z;                        % Vertex 1
        x + sideLengthX, y, z;          % Vertex 2
        x + sideLengthX, y + sideLengthY, z;  % Vertex 3
        x, y + sideLengthY, z;          % Vertex 4
        x, y, z + sideLengthZ;          % Vertex 5
        x + sideLengthX, y, z + sideLengthZ;  % Vertex 6
        x + sideLengthX, y + sideLengthY, z + sideLengthZ;  % Vertex 7
        x, y + sideLengthY, z + sideLengthZ   % Vertex 8
    ];

    % Define the faces of the box
    faces = [
        1, 2, 3, 4;    % Bottom face
        5, 6, 7, 8;    % Top face
        1, 2, 6, 5;    % Side face
        2, 3, 7, 6;    % Side face
        3, 4, 8, 7;    % Side face
        4, 1, 5, 8     % Side face
    ];

    % Plot the box
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', 'blue', 'FaceAlpha', 0.5);
    axis equal;
    grid on;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Box');
end