extends Node2D

var MainScene

var client = StreamPeerTCP.new()
var bIsConnected = false
var connectingDelay = 10
var timeSinceLastConection = 0

var database : SQLite

#var games_folder := "res://imports//"	   # IMPORTANT Harcoded position of the games folders
var games_folder := "res://imports//"	   # IMPORTANT Harcoded position of the games folders

var HOST = "127.0.0.1"
var PORT = 65434

# variables relacionadas al tiempo
#var PathTiempos = "res://important_data.json"
var PathTiempos = "res://fecha-ultimo-correo.json"
var timeManager =Time
var today
var lastEmailDate

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.has_feature("template"):
		Debug.log("si")
		games_folder = OS.get_executable_path().get_base_dir() + "/games/"
	# Cosas para conectar con el servidor de PYTHON
	var result = client.connect_to_host(HOST, PORT)
	if result != OK:
		Debug.log("Failed to connect to socket")
	else:
		Debug.log("Connected to socket")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Debug.log(client.get_status())
	#if Input.is_action_just_pressed("backspace"): # for DEBUG
	#	loadFeedBackText(games_folder)
	# Cosas para conectar con el servidor de PYTHON
	#if timeSinceLastConection >= connectingDelay:
	#Debug.log(client.get_status())
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED and !bIsConnected:
		Debug.log("conectado")
		bIsConnected = true
		client.poll()
		client.put_data("conected".to_ascii_buffer())
		var data = client.get_partial_data(1000)
		#timeSinceLastConection = 0
		#connectingDelay = 60*60*60
	elif client.get_status() == StreamPeerTCP.STATUS_ERROR or client.get_status() == StreamPeerTCP.STATUS_ERROR:
		bIsConnected = false
		client.poll()
		#timeSinceLastConection = 0
		#Debug.log("no_conectado")
	elif client.get_status() == StreamPeerTCP.STATUS_CONNECTING:
		bIsConnected = false
		client.poll()
		#timeSinceLastConection = 0
		#Debug.log("conectando")
	elif bIsConnected:
		timeSinceLastConection = 0
		return
	else:
		bIsConnected = false
		connectingDelay = 10
		client.poll()
		#timeSinceLastConection = 0
		Debug.log("no_conectado")
	timeSinceLastConection += 1
	
	#if client.get_status():
	# Fechas de envio de correos
	today = timeManager.get_date_dict_from_system()
	var file = FileAccess.open(PathTiempos, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var json_important_data = JSON.parse_string(content)
	var tiempos = json_important_data["fecha-ultimo-correo"]
	lastEmailDate = tiempos
	var dif = Global.diferenciaDeTiempos_dias(lastEmailDate, today)
	#Debug.log(dif)
	if dif >= 31 and bIsConnected: # diferencia de al menos un mes
		loadFeedBackText(games_folder) # EMAILS
		Debug.log("enviando correos")
		file = FileAccess.open(PathTiempos, FileAccess.WRITE)
		json_important_data["fecha-ultimo-correo"] = today
		file.store_string(JSON.stringify(json_important_data))
		file.close()
		file = null
	return


# :------------------------------ v0.1 General PYTHON conection Methods -----------------------------: #

func on_send_email_info(messagge_to_send):
	if bIsConnected:
		var json_to_send = JSON.stringify(messagge_to_send)
		# SEND THE JSON MESSAGGE
		Debug.log("json to send: " + str(json_to_send))
		client.put_data(json_to_send.to_ascii_buffer())
		var data = client.get_partial_data(1000)
		Debug.log("respuesta: "+str(data))
		if data.size() > 0:
			
			var messagge_to_decode = PackedByteArray(data[1])
			var decodedString = messagge_to_decode.get_string_from_utf8()
			Debug.log(decodedString)
			if decodedString.length() > 3: 
				var in_messagge = JSON.parse_string(decodedString)
				Debug.log(in_messagge)
			#if in_messagge.purpose == 1:
			#	return true
			return true
		return false
	else: 
		return false


func on_send_info(messagge_to_send):
	if bIsConnected:
		var json_to_send = JSON.stringify(messagge_to_send)
		# SEND THE JSON MESSAGGE
		client.put_data(json_to_send.to_ascii_buffer())
		var data = client.get_partial_data(1000)
		Debug.log(data)
		if data.size() > 0:
			
			var messagge_to_decode = PackedByteArray(data[1])
			var decodedString = messagge_to_decode.get_string_from_utf8()
			Debug.log(decodedString)
			if decodedString.length() > 3: 
				var in_messagge = JSON.parse_string(decodedString)
				Debug.log(in_messagge)
			#if in_messagge.purpose == 1:
			#	return true
			return true
		return false
	else: 
		return false


func on_send_rut(messagge_to_send):
	if bIsConnected:
		var json_to_send = JSON.stringify(messagge_to_send)
		# SEND THE JSON MESSAGGE
		client.put_data(json_to_send.to_ascii_buffer())
		await get_tree().create_timer(5).timeout
		var data = client.get_partial_data(10000)
		var data1 = client.get_partial_data(10000)
		if data.size() > 0:
			var messagge_to_decode = PackedByteArray(data[1])
			var decodedString = messagge_to_decode.get_string_from_utf8()
			Debug.log(decodedString)
			if decodedString.length() > 3: 
				#var in_messagge = JSON.parse_string(decodedString)
				return [true, decodedString]
			return [true, {}]
		return [false, {}]
	else: 
		return [false, {}]

func loadFeedBackText(path):
	var dir = DirAccess.open(path)
	Debug.log("path: " + path)
	if dir:
		dir.list_dir_begin()
		#var file_name = dir.get_next()
		var directory_name = dir.get_next()
		while directory_name != "":
			if dir.current_is_dir():
				pass
				#Debug.log("Found directory: " + directory_name)
				var directory = DirAccess.open(path + directory_name)
				directory.list_dir_begin()
				
				var file_name = directory.get_next()
				var bHasLeaderBoard = false
				var files = directory.get_files()
				
				## Fixing possible problems on the folders ##
				var mail = getEmailInfo(path + directory_name + "//", files)
				var feedback_list = []
				if mail.length()  >= 3:
					feedback_list = getFeedback(path + directory_name + "//", files)
				#Debug.log("feedback: "+str(feedback_list))
				if feedback_list.size() != 0 and mail.length()  >= 3:
					var dict = {
						"purpose": "email",
						"feedback": [],
						"email": mail
						}
					for f in feedback_list:
						dict["feedback"].append(f["text"])
					Debug.log("feedback to correo: "+str(dict))
					on_send_email_info(dict)
			else:
				Debug.log("file outside a folder, fix")
			
			directory_name = dir.get_next()
		#$VScrollBar.custom_minimum_size = Vector2(200, 400)
	else:
		Debug.log("An error occurred when trying to access the path.")

func getFeedback(path, inFiles):
	if "feedback.db" in inFiles:
		#Debug.log("no db")
		database = SQLite.new()
		database.path= path + "feedback.db"
		#Debug.log("asdasd: "+ path + "feedback.db")
		database.open_db()
		if database.query("SELECT *
			FROM FeedBack"):
			var inFeedBack = []# = database.select_rows("LeaderBoards", "", ["*"])
			for data in database.query_result:
				inFeedBack.append(data)
				#var scoreData = database.select_rows("LeaderBoards", "", ["*"])
			database.close_db()
			return inFeedBack
	return []

func getEmailInfo(path, inFiles):
	if "info.json" in inFiles:
		var file = FileAccess.open(path + "info.json", FileAccess.READ)
		var content = JSON.parse_string(file.get_as_text())
		file.close()
		#Debug.log(content)
		return content["email"]
	return ""

# :------------------------------ Methods for card waiting and receiving info -----------------------------: #

func notify_card_waiting():
	var dict = {
		"purpose": "waitingCard"
		}
	on_send_info(dict)
	return

func notify_stop_waiting():
	var dict = {
		"purpose": "StopwaitingCard"
		}
	on_send_info(dict)
	return

func requestPlayerInfo(inRUT):
	var dict = {
		"purpose": "sending_rut",
		"user-rut":str(inRUT)
		}
	var player_data = await on_send_rut(dict)
	return player_data
