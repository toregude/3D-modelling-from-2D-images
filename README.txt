Usage:
The program is started by running the main.m file. Then a dialog box opens, with two buttons, "Cancel" and "Browse folder". By pressing "Cancel", the program is exited, and by pressing "Browse folder" the user is able to select the folder containing the appropriate image and .txt files for the 3D model generation. The selected folder needs to contain two additional folders, one named "images" containing the images, and one named "parameters", containing a camera.txt file and images.txt file. The camera.txt file, used for the calibration of the 2D images, needs to contain the camera parameters in this specific format: "CAMERA_ID, MODEL, WIDTH, HEIGHT, PARAMS[]". When the images.txt file containts information about the camera position on this format, "ID X Y Z (camera pos) Camera Imagename", the scaling ambigity in estimating the pose between images are solved by utilizing the camera positions. If the file is in another order or does not contain the right information, the program still executes, but without solving the scaling ambigity.

When the model of the room is finished a button with Draw Model show. Click on the button and a 3D model of the room is shown, allowing the user to click on two points in the room and the distance between them displays.

The test set "office" is part of the ETH3D datasets, which may be found here: https://www.eth3d.net/datasets.

Needed official Matlab toolboxes:
Statistics and Machine Learning Toolbox
Image Processing Toolbox
Computer Vision Toolbox
