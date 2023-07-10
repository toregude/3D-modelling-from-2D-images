Usage:
The program is started by running the main.m file. Then a dialog box opens, with two buttons, "Cancel" and "Browse folder". By pressing "Cancel", the program is exited, and by pressing "Browse folder" the user is able to select the folder containing the appropriate image and .txt files for the 3D model generation. The selected folder needs to contain two additional folders, one named "images" containing, and one named "parameters"

References to MATLAB functions used:
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