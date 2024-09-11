% Carregar parâmetros de calibração
sessionData = load('calibrationSession_3mm.mat');
disp(sessionData);
calibrationSession = sessionData.calibrationSession;

% Extraia os parâmetros de calibração estéreo
intrinsics1 = calibrationSession.StereoIntrinsics1;
intrinsics2 = calibrationSession.StereoIntrinsics2;
di

% Definir imagens para processar
I1 = imread('C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_27\camera27_20240906_162215.jpg');
I2 = imread('C:\Users\LCE\Documents\GitHub\Scanner_3D\img_cam_28\camera28_20240906_162215.jpg');

% Retificar as imagens
[J1, J2, reprojectionMatrix] = rectifyStereoImages(I1, I2, stereoParams);

% Realizar a reconstrução 3D
disparityMap = disparitySGM(rgb2gray(J1), rgb2gray(J2));
pointCloud = reconstructScene(disparityMap, stereoParams);

% Visualizar nuvem de pontos
pcshow(pointCloud, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
title('Reconstrução 3D da PCB');
