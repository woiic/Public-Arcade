extends Control

signal game_selected

@onready var title_label = $SelectGameLabel
@onready var buttonsArray :Array
@onready var v_games_container: VBoxContainer = %VGamesContainer
@onready var back_to_main_menu: Button = %BackToMainMenu
@onready var close_session: Button = %CloseSession

@onready var game_img: TextureRect = %GameImg
@onready var game_info: Label = %GameInfo


var database : SQLite

var games:Array
var mod_folder := "res://imports//"	   # IMPORTANT Harcoded position of the games folders

var parent

var GButton = preload("res://scenes/games_button.tscn")

var button_height = 50
var button_spacing = 10
var button_y = 0

#@onready var v_scroll_bar: VScrollBar = $ScrollContainer/VScrollBar

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if OS.has_feature("template"):
		Debug.log("si")
		mod_folder = OS.get_executable_path().get_base_dir() + "/games/"
	
	title_label.show()
	loadGames(mod_folder)
	#$ScrollContainer.ensure_control_visible($ScrollContainer.get_v_scroll_bar())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent.give_PlayerData().name != "":
		close_session.show()
	else:
		close_session.hide()
	return

func loadGames(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		#var file_name = dir.get_next()
		var directory_name = dir.get_next()
		var yReloc = 30
		var cont = 0
		#
		#var button_height = 50
		#var button_spacing = 10
		#var button_y = 0
		
		#while file_name != "":
		while directory_name != "":
			cont += 10
			
			if dir.current_is_dir():
				pass
				#Debug.log("Found directory: " + directory_name)
				var directory = DirAccess.open(path + directory_name)
				directory.list_dir_begin()
				
				var file_name = directory.get_next()
				var bHasLeaderBoard = false
				var files = directory.get_files()
				
				## Fixing possible problems on the folders ##
				checkFiles(path + directory_name + "//", files)
				
				# DEPRECATED
				#while file_name != "":
					## --------------------- Checking Leaderboards --------------------- ##
					#if file_name == "GameLeaderBoard":
					#	bHasLeaderBoard = true
					## --------------------- Adding Game button --------------------- ##
					#var game_button = GButton.instantiate()
					#$VScrollBar.add_child(game_button)
					#game_button.setText(file_name)
					#game_button.setGameDir(path + file_name)
					#buttonsArray.append(game_button)
					#game_button.connect("StartNewGame", StartGame)
					### button positioning ##
					#game_button.button.custom_minimum_size.y = button_height
					#game_button.button.position.y = button_y
					#game_button.button.custom_minimum_size.x = 200
					#button_y += button_height #+ button_spacing
					#file_name = directory.get_next()
			else:
				Debug.log("file outside a folder, fix")
			
			directory_name = dir.get_next()
			yReloc += 20
		#$VScrollBar.custom_minimum_size = Vector2(200, 400)
	else:
		Debug.log("An error occurred when trying to access the path.")


func checkFiles(path, inFiles : Array):
	var bIsGame = false
	if "resumen.txt" not in inFiles:
		addResumen(path)
	if "imagen.png" not in inFiles:
		#Debug.log("no image")
		addImagen(path)
	if "database.db" not in inFiles:
		#Debug.log("no db")
		addDataBase(path)
	if "feedback.db" not in inFiles:
		#Debug.log("no db")
		addFeedbackDataBase(path)
	if "hasFeedback.db" not in inFiles:
		#Debug.log("no db")
		addHasFeedbackDataBase(path)
	if "tiempos.json" not in inFiles:
		#Debug.log("no db")
		addTimesJSON(path)
	if "info.json" not in inFiles:
		#Debug.log("no db")
		addInfoFile(path)
	for file in inFiles:
		if file.contains(".zip"):
			bIsGame = true
			addButtons(path, file)
			#Debug.log("hay juego")
			break
	if !bIsGame:
		Debug.log("no hay juego")
	
	return

func addResumen(path):
	#Debug.log(path)
	var new_file = FileAccess.open(path + "resumen.txt", 7)
	new_file.store_string("lorem ipsum")
	new_file.close()
	return

func addImagen(path):
	#Debug.log(path)
	var new_image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	new_image.fill(Color(64, 24, 208))
	new_image.save_png(path + "imagen.png")
	return

func addDataBase(path):
	database = SQLite.new()
	database.path= path + "database.db"
	database.open_db()
	var table = {
		"id" : {"data_type":"int", "primary_key":true, "not_null":true, "auto_increment":true},
		"name": {"data_type":"text"},
		"score": {"data_type":"int"}
	}
	database.create_table("LeaderBoards",table)
	database.close_db()
	return

func addFeedbackDataBase(path):
	database = SQLite.new()
	database.path= path + "feedback.db"
	database.open_db()
	var table = {
		"text": {"data_type":"text"}
	}
	database.create_table("FeedBack",table)
	database.close_db()
	return

func addHasFeedbackDataBase(path):
	database = SQLite.new()
	database.path= path + "hasFeedback.db"
	database.open_db()
	var table = {
		"nombre": {"data_type":"text"},
		"tiempo": {"data_type":"int"},
		"hasGive": {"data_type":"bool"},
	}
	database.create_table("hasFeedBack",table)
	database.close_db()
	return

func addTimesJSON(path):
	var new_file = FileAccess.open(path + "tiempos.json", 7)
	var tiempos_bsc_str = {
		"tiempo_total":0,
		"numero_usuarios_totales":0
	}
	new_file.store_string(JSON.stringify(tiempos_bsc_str))
	new_file.close()
	return

func addInfoFile(path):
	var file = FileAccess.open(path + "info.json", FileAccess.WRITE)
	var json_default = {"email": ""}
	file.store_string(JSON.stringify(json_default))
	file.close()
	file = null
	return

func addButtons(path, file_name):
	var game_button = GButton.instantiate()
	v_games_container.add_child(game_button)
	#$VScrollBar.add_child(game_button)
	game_button.setText(file_name)
	game_button.setGameDir(path + file_name, path)
	buttonsArray.append(game_button)
	# Conecta al boton con el nuevo juego #
	game_button.connect("StartNewGame", StartGame)
	game_button.connect("ShowGameInfo", ShowGameInfoImg)
	game_button.connect("HideGameInfo", HideGameInfoImg)
	
	## button positioning ##
	
	game_button.custom_minimum_size.y = button_height
	game_button.position.y = button_y
	game_button.custom_minimum_size.x = 200
	button_y += button_height ##+ button_spacing
	return

# Conectado a cada boton
func StartGame(inGame, folder_direction):
	game_selected.emit(folder_direction)
	parent.add_child(inGame)
	#hide()

func ShowGameInfoImg(folder_direction):
	#game_img.texture
	var image = Image.load_from_file(folder_direction + "imagen.png")
	var texture = ImageTexture.create_from_image(image)
	var temp_size = texture.get_size()
	game_img.texture = texture
	#Debug.log(temp_size)
	#if temp_size != Vector2(240, 320):
		#game_img.scale = Vector2(240 / temp_size.x, 320 / temp_size.y)/4.0
	var file = FileAccess.open(folder_direction + "resumen.txt", FileAccess.READ)
	var content = file.get_as_text()
	game_info.text = content
	return

func HideGameInfoImg():
	game_img.texture = ImageTexture.new()
	game_info.text = ""
	return

func _on_back_to_main_menu_pressed() -> void:
	parent.returnToMainMenu()
	return

func _on_close_session_pressed() -> void:
	parent.closeSessionAndReturnToMM()
	return
