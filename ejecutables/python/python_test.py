import json

try:
    print(json.loads("data"))

    a = ""

    a["purpure"]
except TypeError as error:
    print(error)
except json.decoder.JSONDecodeError as error:
    print(error)
#except Exception as error:

print("dab")