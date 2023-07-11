function camera_intrinsics = get_camera_intrinsics(cameras_txt, image_files)
    %Returns camera intrinsics as a cameraIntrisics object

    f_x = cameras_txt(3,5);
    f_y = cameras_txt(3,6);
    c_x = cameras_txt(3,7);
    c_y = cameras_txt(3,8);
    
    image_size = size(im2gray(imread(image_files{1})));
    focal_length = [f_x f_y];
    principal_point = [c_x c_y];
    

    camera_intrinsics = cameraIntrinsics(focal_length, principal_point, image_size);
end

