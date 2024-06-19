import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

def enviar_correo(destinatario, asunto, mensaje):
    # Configuración del servidor SMTP
    servidor_smtp = 'smtp.gmail.com'
    puerto = 587  # Puerto típico para SMTP

    # Dirección de correo electrónico y contraseña
    remitente = 'memoriaarcade@gmail.com'
    contraseña = 'ohts cpfc lrte dyfu'    

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

# Llamar a la función para enviar el correo
destinatario = 'lh-swysen@hotmail.com'
asunto = 'Asunto del correo'
mensaje = 'Este es un correo de prueba enviado desde Python.'
enviar_correo(destinatario, asunto, mensaje)