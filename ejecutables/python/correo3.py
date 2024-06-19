import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Configuración del servidor SMTP de Outlook
smtp_server = 'smtp.office365.com'
smtp_port = 587  # Puerto TLS de Outlook

# Tu dirección de correo electrónico de Outlook y contraseña
email_address = 'lh-swysen@hotmail.com'
password = '19lobezno98'

# Destinatario del correo electrónico
to_address = 'memoriaarcade@gmail.com'
#to_address = 'jorgesossar@gmail.com'

# Crear un mensaje de correo electrónico
msg = MIMEMultipart()
msg['From'] = email_address
msg['To'] = to_address
msg['Subject'] = 'CHUPAME EL PICO SOSSA'

# Cuerpo del correo electrónico
body = "Hola,\n\nEste es un correo electrónico enviado desde Python. \n\n No sai nah longi ctm \n\n atte yop"
msg.attach(MIMEText(body, 'plain'))

# Iniciar sesión en el servidor SMTP de Outlook
server = smtplib.SMTP(smtp_server, smtp_port)
server.starttls()  # Habilitar el cifrado TLS

# Iniciar sesión en tu cuenta de Outlook
server.login(email_address, password)

# Enviar el correo electrónico
server.sendmail(email_address, to_address, msg.as_string())

# Cerrar la conexión con el servidor SMTP
server.quit()

print('Correo electrónico enviado correctamente.')
