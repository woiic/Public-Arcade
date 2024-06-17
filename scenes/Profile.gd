extends Control

@onready var nombre: Label = $Nombre
@onready var imagen: TextureRect = $Imagen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setProfile(in_nombre, in_img_direction):
	nombre.text = in_nombre
	#var texture = load(in_img_direction)
	#var texture = ResourceLoader.load(in_img_direction)
	var image = Image.load_from_file(in_img_direction)
	var texture = ImageTexture.create_from_image(image)
	var temp_size = texture.get_size()
	Debug.log(temp_size)
	if temp_size != Vector2(240, 320):
		imagen.texture = texture
		imagen.scale = Vector2(240 / temp_size.x, 320 / temp_size.y)/4.0
		return
	imagen.texture = texture
	imagen.scale = imagen.scale/4.0
	return

func removeProfile():
	nombre.text = ""
	imagen.texture = null
	imagen.scale = Vector2(1, 1)
	return
