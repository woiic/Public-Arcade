# Proyecto de memoria Arcade 

## Instalación

0. Instala Godot 4.2.x.
1. Clona este repositorio.
2. Abre Godot e importa el proyecto.


## Setup

Una vez instalado, es posible probar la aplicación de 2 formas, a traves del ultimo ejecutable generado, para probar como será dentro del Arcade, o dentro del proyecto y poder tener una forma de debugear en caso de haber problemas.
Con el ejecutable es necesario entrar en la carpeta `res://ejecutables/`, donde hay un ejecutable del programa y otra carpeta llamada `games`, dentro de esta carpeta debes añadir tu juego dentro de una nueva carpeta con el mismo nombre de tu juego, por lo que quedará de la siguiente forma `res://ejecutables/games/mi_juego`. Dentro de esta carpeta debes añadir el archivo pck de tu juego. Es necesario que dentro del juego se cree una nueva carpeta con el mismo nombre que en la carpeta games, y dentro de esta se encuentre el archivo de tu escena main.tscn, pero renombrada de forma `ArcadeMain.tscn`, por lo que su ruta será `res://mi_juego/ArcadeMain.tscn`. Si no tienen el mismo nombre las carpetas, no se podrá encontrar el archivo del juego.
En caso de probarlo desde el proyecto, es necesario repetir este proceso, pero dentro de la carpeta `res://imports` y que quede `res://imports/games/`.

El juego debe ser añadido en formato .zip, para esto debes entrar a tu proyecto y exportarlo para windows.
![image](https://github.com/woiic/Arcade/assets/40223167/af63c8aa-9035-4e81-95a7-8a8d06658ea0)

Además del archivo PCK, es necesario añadir 3 archivos más que deben llamarse como viene señalado.
Un archivo de texto, llamado `resumen.txt` que contenga un pequeño resumen que describa el contenido de tu juego, para luego ser mostrado dentro del selector de juegos de la aplicación.
Una imagen llamada `imagen.png` que muestre visualmente el juego.
Un archivo json, llamado `info.json` que contenga (de momento) una sola clave con el correo de los desarrolladores para luego enviar la retroalimentación de los usuarios. `{"email":"tu_correo@electronico.com"}`

## Desarrollo
A continuación, se explica cómo usar los métodos y características de la aplicación para añadir tu juego/demo.

### Métodos
Dentro de la aplicación se puede obtener información de los usuarios, u otras funcionalidades aquí explicadas, pero es obligatorio que no existan ninguna escena de nombre Global para poder acceder a esta información.

#### PlayerData
Los usuarios cuando inician sesión, se les guarda su información dentro de una clase llamada PlayerData que tiene de varibles

```gdscript
class PlayerData:
  var id : int   # identificador único de cada usuario
  var name : String   # nombre del usuario
  var image : String   # ruta a donde se guarda la imagen del usuario
  var guest : bool   # booleano que informa si el usuario está registrado o no dentro de la universidad
```
Para obtener la información de los usuarios es necesario llamar primero a la escena Global que siempre está presente, un ejemplo aquí:
```gdscript
func getPD():
  if(Global):
    Global.get_PlayerData()
  return
```
Dentro de Global, los métodos accesibles son:
`Global.get_PlayerData()`: Devuelve un objeto PlayerData que contiene la información del usuario. NO SE DEBE MODIFICAR.

`Global.game_over(score : int)`: Recibe un valor "score", que contiene el puntaje obtenido por el usuario de turno.

`Global.showLeaderBoard()`: Se muestra al usuario una escena con los puntajes y nombres de los usuarios dentro del juego, es posible que no funcione durante una pausa (TO TEST).

`Global.closeGame()`: Se cierra el juego y se vuelve al selector de juegos cerrando la aplicación.

## Limitaciones

La aplicación tiene algunas limitaciones desde el punto de vista del desarrollo.

1. No es posible utilizar autoload, a menos que se añadan directamente dentro de los autoloads del proyecto.
2. No es posible utilizar la función `change_scene()`, ya que esto elimina la escena Main de la aplicación.
3. De forma local no se puede acceder a datos de usuario de la Universidad, debido a que es necesario utilizar una cuenta autorizada, pero se puede utilizar el sistema de "guests" o invitados para hacer pruebas.

