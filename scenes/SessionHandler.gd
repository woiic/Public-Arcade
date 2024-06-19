extends Control

signal endpoint_response(response)
signal on_player_session(player_data)
signal guest_session(guest_data)

# DEPRECATED
#enum SessionState {
#WaitingCard = 0,
#WaitingUserInfo,
#InfoSended,
#}

var player_data

#var ActualSessionState : SessionState
var parent
var besperandoRespuesta : bool = false


@onready var main_label: Label = $MainLabel
@onready var guest_button: Label = $GuestButton
@onready var simular_tarjeta: Button = $SimularTarjeta

@onready var name_input: LineEdit = $LineEdit
@onready var enter_guest_button: Button = $EnterGuestButton

@onready var user_rut: LineEdit = %user_rut
@onready var insert_rut: Button = %insertRUT

@onready var profile_img: TextureRect = %ProfileImg
@onready var debug_nombre_usuario: Label = $Debug_nombreUsuario
@onready var if_error: Label = $IfError

@onready var esperando_respuesta: Label = %EsperandoRespuesta
@onready var back_to_main_menu: Button = %BackToMainMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	#ActualSessionState = SessionState.WaitingCard
	#name_input.hide()
	#enter_guest_button.hide()
	esperando_respuesta.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if besperandoRespuesta:
		esperando_respuesta.show()
	else:
		esperando_respuesta.hide()
	pass

func send_id_to_endpoint(CardId):
	# Aca se tiene que enviar la info del Id del usuario al endpoint
	return
#
#func _on_guest_entering() -> void:
	#guest_button.hide()
	#name_input.show()
	#enter_guest_button.show()
	#pass # Replace with function body.


func _on_enter_guest() -> void:
	if besperandoRespuesta:
		return
	var image : String = "res://images/default_user_image.png"
	if OS.has_feature("template"):
		Debug.log("si")
		image = OS.get_executable_path().get_base_dir() + "/images/default_user_image.png"
	var name = name_input.text
	if name == "":
		return
	var guest_player_data = Global.PlayerData.new(0, name, image, "", true)
	name_input.text = ""
	user_rut.text = ""
	guest_session.emit(guest_player_data)
	return

# FOR DEBUG, DEPRECATED
func _on_simular_tarjeta() -> void:
	var id : int = 1
	var name : String = "Dummy Data"
	var image : String = "res://images/default_user_image.png"
	var faculty : String = "FCFM"
	var guest : bool = false
	#var name = name_input.text
	if name == "":
		return
	var player_data = Global.PlayerData.new(id, name, image, faculty, true)
	on_player_session.emit(player_data)
	return


func _on_insert_rut_pressed() -> void:
	if besperandoRespuesta:
		return
	#Debug.log("añadido rut")
	if user_rut.text.length() > 0:
		showWaitingResponse()
		var userData = await parent.getUserInfoFromAPI(user_rut.text)
		hideWaitingResponse()
		#Debug.log(userData)
		if typeof(userData[1]) == TYPE_DICTIONARY and userData[1].size() < 1:
			if_error.text = "No hay respuesta del servidor"
			return
		var json = JSON.parse_string(userData[1])
		#Debug.log(json)
		if json.size() < 1:
			if_error.text = "No hay respuesta del servidor"
			return
		elif json["purpose"] == "received":
			var in_image = "res://" + json["foto_direction"]
			
			if OS.has_feature("template"):
				Debug.log("si")
				in_image = OS.get_executable_path().get_base_dir() + "/" + json["foto_direction"]
			var in_name = json["nombre"]
			var id : int = 0
			id = int(user_rut.text.split("-")[0])
			var faculty : String = ""
			var guest : bool = false
			if name == "":
				return
			var in_player_data = Global.PlayerData.new(id, in_name, in_image, faculty, true)
			#loading here before hand
			#var texture = load(in_image)
			var texture = Image.load_from_file(in_image)
			on_player_session.emit(in_player_data)
			name_input.text = ""
			user_rut.text = ""
		elif json["purpose"] == "error":
			if_error.text = json["reason"]
			return
		return
	return

func showWaitingResponse():
	besperandoRespuesta = true
	return

func hideWaitingResponse():
	besperandoRespuesta = false
	return


func _on_back_to_main_menu_pressed() -> void:
	name_input.text = ""
	user_rut.text = ""
	parent.returnToMainMenu()
	return
