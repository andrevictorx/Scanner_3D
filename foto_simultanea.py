import cv2
import threading
import time
from datetime import datetime

# Função para gerar um nome de arquivo único baseado no timestamp
def generate_filename(camera_id):
    camera_id = camera_id + 27
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return f"img_cam_{camera_id}/camera{camera_id}_{timestamp}.jpg"

# Função para capturar imagens de ambas as câmeras ao mesmo tempo e salvar simultaneamente
def capture_image_from_both_cameras(cam1_id=0, cam2_id=1, width=1280, height=720):
    # Acessa ambas as câmeras
    cap1 = cv2.VideoCapture(cam1_id)
    cap2 = cv2.VideoCapture(cam2_id)
    
    # Verifica se as câmeras foram abertas corretamente
    if not cap1.isOpened():
        print(f"Erro ao acessar a câmera {cam1_id}")
        return
    if not cap2.isOpened():
        print(f"Erro ao acessar a câmera {cam2_id}")
        return
    
    # Define a resolução das câmeras
    cap1.set(cv2.CAP_PROP_FRAME_WIDTH, width)
    cap1.set(cv2.CAP_PROP_FRAME_HEIGHT, height)
    
    cap2.set(cv2.CAP_PROP_FRAME_WIDTH, width)
    cap2.set(cv2.CAP_PROP_FRAME_HEIGHT, height)

    while True:
        # Lê as imagens das duas câmeras
        ret1, frame1 = cap1.read()
        ret2, frame2 = cap2.read()

        if ret1 and ret2:
            # Mostra o feed de vídeo das duas câmeras em tempo real
            cv2.imshow(f"Camera {cam1_id}", frame1)
            cv2.imshow(f"Camera {cam2_id}", frame2)

            # Ao pressionar 's', salva simultaneamente as imagens de ambas as câmeras
            if cv2.waitKey(1) & 0xFF == ord('s'):
                filename1 = generate_filename(cam1_id)
                filename2 = generate_filename(cam2_id)
                cv2.imwrite(filename1, frame1)
                cv2.imwrite(filename2, frame2)
                print(f"Fotos das câmeras {cam1_id} e {cam2_id} salvas como {filename1} e {filename2}")

            # Pressione 'q' para sair da visualização
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
        else:
            print(f"Erro ao capturar imagem das câmeras {cam1_id} e {cam2_id}")
            break
    
    # Libera as câmeras e fecha as janelas
    cap1.release()
    cap2.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    start_time = time.time()
    capture_image_from_both_cameras()
    print(f"Captura finalizada em {time.time() - start_time} segundos")
