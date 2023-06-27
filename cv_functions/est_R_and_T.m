% Assuming you already have the essential matrix E and corresponding matched points

%%Estimate K
calibrationData = cameraCalibrator;
calibrationData.addImage(I1);
calibrationData.calibrate;
intrinsics = calibrationData.CameraParameters.IntrinsicMatrix;

% Decompose the essential matrix into the rotation and translation matrices
[R, T] = essentialMatrixToCameraPose(E);

% Normalize the points to image coordinates
normalizedPoints1 = points1.Location;
normalizedPoints2 = points2.Location;

% Convert the points to homogeneous coordinates
points1Homogeneous = [normalizedPoints1, ones(size(normalizedPoints1, 1), 1)];
points2Homogeneous = [normalizedPoints2, ones(size(normalizedPoints2, 1), 1)];

% Triangulate the 3D coordinates of the points
points3D = triangulate(points1Homogeneous, points2Homogeneous, cameraParams1, cameraParams2);

% Display the 3D coordinates
disp('3D Coordinates:');
disp(points3D);