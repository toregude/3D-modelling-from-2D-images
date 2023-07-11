Usage:
The program is started by running the main.m file. Then a dialog box opens, with two buttons, "Cancel" and "Browse folder". By pressing "Cancel", the program is exited, and by pressing "Browse folder" the user is able to select the folder containing the appropriate image and .txt files for the 3D model generation. The selected folder needs to contain two additional folders, one named "images" containing the images, and one named "parameters", contating a camera.txt file and images.txt file. The camera.txt file needs to contain the camera parameters in this order
CAMERA_ID, MODEL, WIDTH, HEIGHT, PARAMS[]
for the calibration of the 2D images. When the images.txt file containts information about the camera position in this order
ID X Y Z (camera pos) Camera Imagename
the scaling ambigity in estimating the pose between images are solved taking advantage of the camera positions. If the file is in another order or dosn't contain the right information, the program still execute, but without solving the scaling ambigity. 

Needed official Matlab Toolboxes:
image_toolbox
matlab
statistics_toolbox
video_and_image_blockset

Readme: Lag en Readme.txt-fil som inneholder en veiledning til applikasjonen din og en liste over alle verktøykassene som trengs for å kjøre applikasjonen.

Extract Harris Features
-function name: detectHarrisFeatures
-tool box: Computer Vision Toolbox
-documentation: https://de.mathworks.com/help/vision/ref/detectharrisfeatures.html

Match Features
-function name: matchFeatures
-tool box: Computer Vision Toolbox
-documentation: https://de.mathworks.com/help/vision/ref/matchfeatures.html

Estimating Essential matrix
-function name: estimateEssentialMatrix
-tool box: Computer Vision Toolbox
-documentation: https://de.mathworks.com/help/vision/ref/estimateessentialmatrix.html

Estimating R og T from E

-function name: estrelpose
-tool box: Computer Vision Toolbox
-documentation: https://de.mathworks.com/help/vision/ref/estrelpose.html

dbscan

-estrelpose
-https://de.mathworks.com/help/vision/ref/estrelpose.html

3-D locations of undistorted matching points in stereo images
-triangulate
-https://se.mathworks.com/help/vision/ref/triangulate.html

Returns a 3-by-4 camera projection matrix
-cameraProjection
-https://se.mathworks.com/help/vision/ref/cameraprojection.html?s_tid=doc_ta

Apply forward geometric transformation
-transformPointsForward
-https://se.mathworks.com/help/images/ref/affinetform2d.transformpointsforward.html
