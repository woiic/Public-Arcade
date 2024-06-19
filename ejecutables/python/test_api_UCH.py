from PIL import Image
from base64 import decode

file = open("D://UCH//Semestre_2023_02//Memoria//MemoriaGodot//python//foto.txt", 'r')
imagestr = file.read()
imagestr = imagestr.encode()
# using tobytes data as raw for frombyte function 

img = Image.frombytes("L", (100, 100), imagestr, 'raw') 
img.save("imagen_de_prueba.png")
# creating list

img.show()
img1 = list(img.getdata()) 
