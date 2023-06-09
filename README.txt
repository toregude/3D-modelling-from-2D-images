In this repository, one can add a minumum of two images of a room to get a 3D model of the room, with sizes and distances
of all objects visible in the pictures. 

List of toolboxes used:
- points = detectHarrisFeatures(I)
- indexPairs = matchFeatures(features1,features2)
- RGB = insertMarker(I,position)
- showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2)