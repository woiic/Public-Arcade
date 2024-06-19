import socket
import json

HOST = '127.0.0.1'
PORT = 65432
bEnvioMensage = False
while True:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
        server_socket.bind((HOST, PORT))
        server_socket.listen()

        print(f"Server listening on {HOST}:{PORT}")
        print(1)
        conn, addr = server_socket.accept()
        print(2)
        with conn:
            print(f"Connected by {addr}")
            bIsConnected = True
            while bIsConnected:
                try:
                    data = conn.recv(1024)
                    if not data:
                        break
                    print(f"Received: {data.decode()}")
                    message = json.dumps({"mensaje1": "hola", "mensaje2": "chao"})
                    #message = "hola"
                    conn.sendall(message.encode())
                    #conn.send(message)
                except:
                    print("F")
                    bIsConnected = False
