path = '.\kicker_dslr_undistorted\kicker\dslr_calibration_undistorted\points3D.txt';
%path = '.\delivery_area_dslr_undistorted (ONLY FOR DEBUGGING)\delivery_area\dslr_calibration_undistorted\points3D.txt';

points3D = get_global_coordinates_list_test(path);
get_global_coordinates_list(points3D);



% % allah = [[1, 2, 4]; [3, 1, 8]; [7, 13, 16]; [13, 8, 14]]
% % 
% % kjartan = allah(allah(:, 2) < 3, :)
