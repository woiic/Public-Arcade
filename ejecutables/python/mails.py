import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def enviar_correo(destinatario, asunto, mensaje):
    # Configuración del servidor SMTP
    servidor_smtp = 'smtp.gmail.com'
    puerto = 587  # Puerto típico para SMTP

    # Dirección de correo electrónico y contraseña
    remitente = 'memoriaarcade@gmail.com' # HARDCODED
    contraseña = 'ohts cpfc lrte dyfu'    # HARDCODED

    # Crear el objeto del mensaje
    msg = MIMEMultipart()
    msg['From'] = remitente
    msg['To'] = destinatario
    msg['Subject'] = asunto

    # Añadir el cuerpo del mensaje
    msg.attach(MIMEText(mensaje, 'plain'))

    # Iniciar conexión con el servidor SMTP
    with smtplib.SMTP(servidor_smtp, puerto) as servidor:
        servidor.starttls()  # Iniciar una conexión segura
        servidor.login(remitente, contraseña)
        texto = msg.as_string()
        servidor.sendmail(remitente, destinatario, texto)

def enviar_multiples_correo(destinatarios, asunto, mensajes):
    # Configuración del servidor SMTP
    servidor_smtp = 'smtp.gmail.com'
    puerto = 587  # Puerto típico para SMTP

    # Dirección de correo electrónico y contraseña
    remitente = 'memoriaarcade@gmail.com' # HARDCODED
    contraseña = 'ohts cpfc lrte dyfu'    # HARDCODED

    # Iniciar conexión con el servidor SMTP
    with smtplib.SMTP(servidor_smtp, puerto) as servidor:
        servidor.starttls()  # Iniciar una conexión segura
        servidor.login(remitente, contraseña)
        for i in range(len(destinatarios)):
            destinatario = destinatarios[i]
            # Crear el objeto del mensaje
            msg = MIMEMultipart()
            msg['From'] = remitente
            msg['Subject'] = asunto
            msg['To'] = destinatario
            mensaje = mensajes[i]
            msg.attach(MIMEText(mensaje, 'plain'))
            texto = msg.as_string()
            print(msg)
            try:
                servidor.sendmail(remitente, destinatario, texto)
            except:
                print(f"Error con destinatario:{destinatario}, y mensaje {texto}")



# Llamar a la función para enviar el correo
#destinatario = 'lh-swysen@hotmail.com'
#enviar_correo(destinatario, asunto, mensaje)

#destinatarios = ['jorgesossar@gmail.com','jorgesossar@gmail.com','lh-swysen@hotmail.com','loicswisen@gmail.com']
#asunto = "prueba de correos multiples"
#mensajes = ["mensaje nro1", "mensaje nro2", "mensaje nro3", "mensaje nro4"]
#enviar_multiples_correo(destinatarios, asunto, mensajes)