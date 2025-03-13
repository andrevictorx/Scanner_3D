% Carregar a sessão de calibração salva
load('calibrationSession_3mm.mat');

% Extrair os parâmetros de calibração da sessão
stereoParams = calibrationSession.CameraParameters;

% Acessar os parâmetros de cada câmera
cameraParams1 = stereoParams.CameraParameters1;
cameraParams2 = stereoParams.CameraParameters2;

% A distância focal em pixels pode ser obtida a partir da matriz intrínseca
focalLength1 = cameraParams1.IntrinsicMatrix(1, 1);  % Distância focal da câmera 1
disp(focalLength1);
focalLength2 = cameraParams2.IntrinsicMatrix(1, 1);  % Distância focal da câmera 2
disp(focalLength2);
% Normalmente, a distância focal deve ser a mesma para ambas as câmeras em um sistema estéreo calibrado
focalLength = (focalLength1 + focalLength2) / 2;
disp(focalLength);
% Extrair a matriz de rotação e translação
T = stereoParams.PoseCamera2.Translation; % Vetor de translação da câmera 2 em relação à câmera 1

% A baseline é a magnitude da translação entre as duas câmeras
baseline = norm(T);

% Criar dois objetos de vídeo, um para cada câmera
vid1 = videoinput('winvideo', 1, 'MJPG_1280x720');  % Câmera 1
vid2 = videoinput('winvideo', 2, 'MJPG_1280x720');  % Câmera 2

% Definir a quantidade de frames a serem capturados (apenas 1)
vid1.FramesPerTrigger = 1;
vid2.FramesPerTrigger = 1;

% Capturar uma imagem de cada câmera
frame1 = getsnapshot(vid1);
frame2 = getsnapshot(vid2);

% Verificar a resolução das imagens capturadas
disp('Resolução das imagens capturadas:');
disp(size(frame1));  % Tamanho da imagem da câmera 1
disp(size(frame2));  % Tamanho da imagem da câmera 2

% Gerar timestamp para nomear as imagens
timestamp = datetime('now');
timestamp_str = datestr(timestamp, 'yyyy-mm-dd_HH-MM-SS');

% Retificar as imagens capturadas usando os parâmetros de calibração estéreo
[frameLeftRect, frameRightRect, reprojectionMatrix] = ...
    rectifyStereoImages(frame1, frame2, stereoParams);

% Verificar a resolução das imagens retificadas
disp('Resolução das imagens retificadas:');
disp(size(frameLeftRect));  % Tamanho da imagem retificada da câmera 1
disp(size(frameRightRect));  % Tamanho da imagem retificada da câmera 2

% Exibir anaglifo estéreo
figure;
imshow(stereoAnaglyph(frameLeftRect, frameRightRect));
title("Rectified Stereo Images");

% Opcional: Salvar as imagens retificadas com nomes únicos
imwrite(frameLeftRect, ['img_cam_27\', timestamp_str, '.jpg']);
imwrite(frameRightRect, ['img_cam_28\', timestamp_str, '.jpg']);

% Converter as imagens retificadas para escala de cinza
frameLeftGray  = im2gray(frameLeftRect);
frameRightGray = im2gray(frameRightRect);

% Calcular o mapa de disparidade
disparityMap = disparitySGM(frameLeftGray, frameRightGray);

% Exibir o mapa de disparidade
figure;
imshow(disparityMap, [0, 64]);
title("Disparity Map");
colormap jet;
colorbar;

% Calcular a profundidade
depthMap = (focalLength * baseline) ./ disparityMap;

% Exibir o mapa de profundidade
figure;
imshow(depthMap, [min(depthMap(:)), max(depthMap(:))]);
title('Depth Map');
colormap jet;
colorbar;

% Liberar os objetos de vídeo
delete(vid1);
delete(vid2);

disp('Fotos tiradas, retificadas e salvas com sucesso!');
