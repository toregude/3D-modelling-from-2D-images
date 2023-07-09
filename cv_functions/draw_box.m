
function draw_box(origin, sideLengths)
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
        x - sideLengthX/2, y - sideLengthY/2, z - sideLengthZ/2;
        x + sideLengthX/2, y - sideLengthY/2, z - sideLengthZ/2;
        x + sideLengthX/2, y + sideLengthY/2, z - sideLengthZ/2;
        x - sideLengthX/2, y + sideLengthY/2, z - sideLengthZ/2;
        x - sideLengthX/2, y - sideLengthY/2, z + sideLengthZ/2;
        x + sideLengthX/2, y - sideLengthY/2, z + sideLengthZ/2;
        x + sideLengthX/2, y + sideLengthY/2, z + sideLengthZ/2;
        x - sideLengthX/2, y + sideLengthY/2, z + sideLengthZ/2
    ];

        

    % Define the faces of the box
    faces = [
        1, 2, 3, 4;
        5, 6, 7, 8;
        1, 2, 6, 5;
        2, 3, 7, 6;
        3, 4, 8, 7;
        4, 1, 5, 8
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