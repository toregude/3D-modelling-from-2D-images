function intrinsics = intrinsics_from_cameraparams(camerastxt, imageFiles)
    fx = camerastxt(3,5);
    fy = camerastxt(3,6);
    cx = camerastxt(3,7);
    cy = camerastxt(3,8);

    K = [fx 0 cx; 0 fy cy; 0 0 1];
    
    imageSize = size(im2gray(imread(imageFiles{1})));
    focalLength = [K(1,1) K(2,2)];
    principalPoint = [K(1,3) K(2,3)];
    intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);
end

