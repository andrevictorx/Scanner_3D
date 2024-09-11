import cv2
import threading
import time
from datetime import datetime

# Função para gerar um nome de arquivo único baseado no timestamp
def generate_filename(camera_id):
    camera_id = camera_id + 27
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return f"img_cam_{camera_id}/camera{camera_id}_{timestamp}.jpg"

# Função para capturar imagem de uma câmera
def capture_image(camera_id, width=1280, height=720):
    # Acessar a câmera
    cap = cv2.VideoCapture(camera_id)
    
    # Verifica se a câmera foi aberta corretamente
    if not cap.isOpened():
        camera_id = camera_id + 27
        print(f"Erro ao acessar a câmera {camera_id}")
        camera_id = camera_id - 27
        return
    
    # Define a resolução da câmera
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, width)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, height)
    
    # Lê a imagem da câmera
    ret, frame = cap.read()
    
    if ret:
        # Gera um nome de arquivo único e salva a imagem capturada
        filename = generate_filename(camera_id)
        cv2.imwrite(filename, frame)
        camera_id = camera_id + 27
        print(f"Foto da câmera {camera_id} salva como {filename}")
        camera_id = camera_id - 27
    else:
        camera_id = camera_id + 27
        print(f"Erro ao capturar a imagem da câmera {camera_id}")
        camera_id = camera_id - 27
    
    # Libera a câmera
    cap.release()

# Função para capturar de ambas as câmeras ao mesmo tempo
def capture_from_both_cameras():
    # Cria threads para capturar de duas câmeras simultaneamente
    thread1 = threading.Thread(target=capture_image, args=(1,))
    thread2 = threading.Thread(target=capture_image, args=(0,))
    
    # Inicia as threads
    thread1.start()
    thread2.start()

    # Aguarda ambas as threads terminarem
    thread1.join()
    thread2.join()

if __name__ == '__main__':
    start_time = time.time()
    capture_from_both_cameras()
    print(f"Fotos capturadas em {time.time() - start_time} segundos")
