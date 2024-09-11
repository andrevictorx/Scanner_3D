% Auto-generated by stereoCalibrator app on 09-Sep-2024
%-------------------------------------------------------


% Define images to process
imageFileNames1 = {'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_27\camera27_20240906_162215.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_27\camera27_20240906_162247.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_27\camera27_20240906_162442.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_27\camera27_20240906_163317.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_27\camera27_20240906_163336.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_27\camera27_20240906_163424.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_27\camera27_20240906_164026.jpg',...
    };
imageFileNames2 = {'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_28\camera28_20240906_162215.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_28\camera28_20240906_162247.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_28\camera28_20240906_162442.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_28\camera28_20240906_163317.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_28\camera28_20240906_163336.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_28\camera28_20240906_163424.jpg',...
    'C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_28\camera28_20240906_164026.jpg',...
    };

% Detect calibration pattern in images
detector = vision.calibration.stereo.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames1, imageFileNames2);

% Generate world coordinates for the planar patten keypoints
squareSize = 3;  % in units of 'millimeters'
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Read one of the images from the first stereo pair
I1 = imread(imageFileNames1{1});
[mrows, ncols, ~] = size(I1);

% Calibrate the camera
[stereoParams, pairsUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(stereoParams);

% Visualize pattern locations
h2=figure; showExtrinsics(stereoParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, stereoParams);

% You can use the calibration data to rectify stereo images.
I2 = imread(imageFileNames2{1});
[J1, J2, reprojectionMatrix] = rectifyStereoImages(I1, I2, stereoParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('StereoCalibrationAndSceneReconstructionExample')
% showdemo('DepthEstimationFromStereoVideoExample')



