function rectangle_walls(global_coords)
    max_room = max(global_coords(:, 1:2));
    min_room = min(global_coords(:, 1:2));
    floor_level = find_floor_level(global_coords);
    roof_level = find_roof_level(global_coords);
    walls = [];

    X = [min_room(1), min_room(1), min_room(1), min_room(1)];
    Y = [min_room(2), max_room(2), max_room(2), min_room(2)];
    Z = [floor_level, floor_level, roof_level, roof_level];
        
end