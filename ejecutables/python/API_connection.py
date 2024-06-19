import requests as rq
import json

from PIL import Image
import numpy as np

import base64
from io import BytesIO

#import matplotlib.pyplot as plt
#import matplotlib.image as mpimg
#img = mpimg.imread('your_image.png')
#imgplot = plt.imshow(img)
#plt.show()



API_Key = "f5696a1d457c802bf48b5b2932b3f21e0a0bee42"
test="tokenAuth"
api_direction = "https://api.dcc.uchile.cl/personas/"
def getAPIuserINFO(user_info):
    parameters = {
        #"numero_tarjeta":0,
        #"rut":"19985918-8"
        "rut":"19639149-5"

    }

    headers = {
        "Authorization":"Token "+API_Key
    }
    Security = {
        "tokenAuth": API_Key,
        "basicAuth": "",
        "cookieAuth": ""
    }
    #res = rq.get("https://api.dcc.uchile.cl/personas/",params=parameters,headers=headers,security=Security)
    res = rq.get("https://api.dcc.uchile.cl/personas/",params=parameters,headers=headers)
    print("res = " + str(res))
    inJson = json.loads(res.text)
    print("in json = " + str(inJson))
    return inJson

def getAPIuserINFO_byRUT(in_rut):
    parameters = {
        "rut":str(in_rut)
    }
    headers = {
        "Authorization":"Token "+API_Key
    }
    
    res = rq.get(api_direction,params=parameters,headers=headers)
    #print(res.text)
    if res.status_code == 200:
        inJson = json.loads(res.text)
        #print("in json = " + str(inJson))
        in_dict = inJson[0]
        in_dict["status"] = "OK"
        return inJson[0]
    else:
        inJson = json.loads(res.text)
        inJson["status"] = "error"
        return inJson

def savePFP(coded_img, img_direction=""): # "pro file photo"
    base64_str = coded_img

    image_data = base64.b64decode(base64_str)
    image = BytesIO(image_data)
    img = Image.open(image)
    if img_direction.lower().endswith(".png"):
        img.save(img_direction)
    else:
        img.save("ProfilePicture/profileImg.png")
        return "ProfilePicture/profileImg.png"
    return img_direction

#print(getAPIuserINFO_byRUT("19985918-8"))