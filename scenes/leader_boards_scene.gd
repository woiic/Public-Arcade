extends Control

signal game_leaderboard_selected
signal back_to_menu

@onready var title_label = $SelectGameLabel
@onready var buttonsArray :Array
@onready var LeaderBoardsTable: Label = $LeaderBoardsTable
@onready var MainMenuButton: Button = $BackToMainMenuButton
@onready var tables_container: GridContainer = %TablesContainer

var database : SQLite
var parent

var tables_folder := "res://imports//"     #Harcoded position of the games folders
var GButton = preload("res://scenes/leader_board_button.tscn")

var button_height = 50
var button_spacing = 10
var button_y = 0

#@onready var v_scroll_bar: VScrollBar = $ScrollContainer/VScrollBar

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if OS.has_feature("template"):
		Debug.log("si")
		tables_folder = OS.get_executable_path().get_base_dir() + "/games/"
	
	title_label.show()
	parent = get_parent()
	#loadGames(mod_folder)
	loadTables(tables_folder)
	#$ScrollContainer.ensure_control_visible($ScrollContainer.get_v_scroll_bar())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func loadGames(path):
func loadTables(path):
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
				#checkFiles(path + directory_name + "//", files)
				checkDatabase(path + directory_name + "//", files)
				
			else:
				Debug.log("file outside a folder, fix")
			
			directory_name = dir.get_next()
			yReloc += 20
		$ScrollContainer.custom_minimum_size = Vector2(200, 400)
	else:
		Debug.log("An error occurred when trying to access the path.")

# DEPRECATED
#func checkFiles(path, inFiles : Array):
	#var bIsGame = false
	#if "resumen.txt" not in inFiles:
		#addResumen(path)
	#if "imagen.png" not in inFiles:
		#Debug.log("no image")
		#addImagen(path)
	#if "database.db" not in inFiles:
		#Debug.log("no db")
		#addDataBase(path)
	#for file in inFiles:
		#if file.contains(".zip"):
			#bIsGame = true
			#addButtons(path, file)
			#Debug.log("hay juego")
			#break
	#if !bIsGame:
		#Debug.log("no hay juego")
	#
	#return


func checkDatabase(path, inFiles : Array):
	if "database.db" in inFiles:
		#Debug.log("hay db")
		var game_name = ""
		for file in inFiles:
			if file.contains(".zip"):
				game_name = file.get_slice(".zip",0)
				
		for file in inFiles:
			if file.contains(".db"):
				addLeaderBoardsButtons(path, file, game_name)
				#Debug.log("hay juego")
				break
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

# DEPRECATED
#func addButtons(path, file_name):
	#var game_button = GButton.instantiate()
	#$ScrollContainer.add_child(game_button)
	#game_button.setText(file_name)
	#game_button.setGameDir(path + file_name, path)
	#buttonsArray.append(game_button)
	## Conecta al boton con el nuevo juego #
	##game_button.connect("StartNewGame", StartGame)
	#
	### button positioning ##
	#
	#game_button.button.custom_minimum_size.y = button_height
	#game_button.button.position.y = button_y
	#game_button.button.custom_minimum_size.x = 200
	#button_y += button_height ##+ button_spacing
	#return

func addLeaderBoardsButtons(path, file_name, game_name):
	var game_button = GButton.instantiate()
	#Debug.log("jahalo")
	$ScrollContainer/VGamesContainer.add_child(game_button)
	game_button.setText(game_name)
	game_button.setGameDir(path + file_name, path)
	buttonsArray.append(game_button)
	# Conecta al boton con el nuevo juego #
	game_button.connect("OpenLeaderBoard", OpenLeaderBoard)
	
	## button positioning ##
	
	game_button.custom_minimum_size.y = button_height
	#game_button.position.y = button_y
	game_button.custom_minimum_size.x = 200
	button_y += button_height ##+ button_spacing
	return


func OpenLeaderBoard(table_data): ## (folder_direction):
	# TODO LEADERBOARD
	
	game_leaderboard_selected.emit(table_data)
	tables_container.setTables(table_data)
	#hide()
	return



func _on_back_to_main_menu_button_pressed() -> void:
	back_to_menu.emit()
	# TODO LEADERBOARD mejorar esto a una tabla de verdad, lo más probable es que con una nueva escena
	LeaderBoardsTable.text = ""
