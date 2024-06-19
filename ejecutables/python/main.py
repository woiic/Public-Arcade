import socket
import json
import os

from PIL import Image, ImageDraw

import base64
from io import BytesIO

import mails as a_emails
import API_connection as user_info

#usb_path = '/media/username/USB_drive'
usb_path = 'D:\\media\\username\\USB_drive'
HOST = '127.0.0.1'
PORT = 65434
bEnvioMensage = False
bEsperandoTarjeta = False

while True:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server_socket:
        server_socket.bind((HOST, PORT))
        server_socket.listen()
        print(f"Server listening on {HOST}:{PORT}")
        connection = True
        conn, addr = server_socket.accept()
        bIsFirstConection = True
        with conn:
            bIsConnected = True
            while connection:
                if bIsConnected:
                #if bIsConnected:
                    # Lo que se hace mientras se está conectado
                    if bIsFirstConection:
                        bIsFirstConection = False
                        data = conn.recv(1024)
                        message = json.dumps({"purpose": "received"})
                        conn.sendall(message.encode())
                    try:
                        # Recibir información desde Godot
                        data = conn.recv(1024)
                        if not data:
                            break
                        print("data: ")
                        print(data)
                        received_messagge = json.loads(data)
                        #try:
                        #    received_messagge = json.loads(data)
                        #except:
                        #    received_messagge = data
                        # Ejemplo mensaje recibido
                        #{
                        #"purpose": "email",
                        #"feedback": [],
                        #"email": mail
                        #}
                        # parsear data segun el tipo de mesaje recibido, matcheando el "purpose" del mensaje
                        if received_messagge["purpose"] == "email":
                            #enviar_multiples_correo(destinatarios, asunto, mensajes)
                            destinatario = received_messagge["email"]
                            asunto = "Envio de FeedBack Arcade"
                            mensaje = "" #received_messagge["feedback"]
                            #for f_i in len(received_messagge["feedback"]):
                            #    mensaje += f"{f_i+1}° {received_messagge[f_i]} \n"
                            cont = 1
                            for f in received_messagge["feedback"]:
                                mensaje += f"{cont}° {f} \n"
                                cont += 1
                            print("correos enviados")
                            message = json.dumps({"purpose": "received"})
                            conn.sendall(message.encode())
                        elif received_messagge["purpose"] == "waitingCard":
                            print("esperando")
                            bEsperandoTarjeta = True
                        elif received_messagge["purpose"] == "StopwaitingCard":
                            bEsperandoTarjeta = False
                        elif received_messagge["purpose"] == "sending_rut":
                            in_rut = received_messagge["user-rut"]
                            userinfo = user_info.getAPIuserINFO_byRUT(in_rut)
                            #print("user_data")
                            print(userinfo)
                            if userinfo["status"] == "OK":
                                print("1")
                                userData = userinfo
                                print(userData)
                                #pfp_direction = user_info.savePFP(userData['foto_base64']) # "pro file photo
                                base64_str = userData['foto_base64']
                                img_direction = ""
                                print("a")
                                image_data = base64.b64decode(base64_str)
                                print("b")
                                image = BytesIO(image_data)
                                print("c")
                                img = Image.open(image)
                                print("d")
                                file_path = os.path.realpath(__file__)
                                img.save(file_path[0:len(file_path) -7] + "ProfilePicture/profileImg.png")
                                pfp_direction = "ProfilePicture/profileImg.png"
                                #print(pfp_direction)
                                pfp_direction = "python/" + pfp_direction
                                print("1")
                                #print(pfp_direction)
                                msg = {
                                    "purpose": "received",
                                    "nombre":userData['nombre_completo'],
                                    "foto_direction":pfp_direction,
                                    "reason": "OK"
                                }
                                print("1")
                                message = json.dumps(msg)
                                print("1")
                                conn.sendall(message.encode())
                            elif userinfo["status"] == "error":
                                userData = userinfo
                                msg = {
                                    "purpose": "error",
                                    "nombre":"",
                                    "foto_direction":"",
                                    "reason": userData["error"]
                                }
                                message = json.dumps(msg)
                                conn.sendall(message.encode())
                            # save image
                        #except:
                            #received_messagge = data
                    #except TypeError:
                    #    print("Received worng paquet format")
                    #except InterruptedError:
                    #    print("Disconnected from godot")
                    #    bIsConnected = False
                    #except json.decoder.JSONDecodeError as error:
                    #    print(error)
                    except:
                        bIsConnected = False
                        connection = False
                        print("error desconocido")
                        print("desconectado")
                #if bEsperandoTarjeta:
                    """
                    usb_files = os.listdir(usb_path)
                    # Imprime la lista de archivos
                    print("Archivos en el dispositivo USB:")
                    for file in usb_files:
                        print(file)
                    if se recibio data de un usuario:
                        bEsperandoTarjeta = False
                        dict = {
                            "purpose": "userInfo",
                            "userInfo": usb_data
                            }

                        message = json.dumps({"purpose": "received"})
                        conn.sendall(message.encode())
                    """
