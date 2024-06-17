#extends Node2D
extends Button

signal StartNewGame
signal ShowGameInfo
signal HideGameInfo

#@onready var button = $Button

var simultaneous_scene
var folder_dir : String 
var project_folder : String
var game_dir = "res://main.tscn"
# to completely fix
var game_scene_name = "//ArcadeMain.tscn"

#var mod_folder := "res://imports/1stExport.zip"
var mod_folder

var gameScene
var parent
# D:\UCH\testsGodot\test0

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent()
	if OS.has_feature("template"):
		Debug.log("si")
		mod_folder = OS.get_executable_path().get_base_dir() + "/games/"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadMods():
	ProjectSettings.load_resource_pack(game_dir, false)
	Debug.log("yos")
	return

func setText(inText: String):
	var buttonText = inText.get_slice(".", 0)
	text = buttonText
	return

func setGameDir(gameDir :String, gameFolder :String):
	#Debug.log("folder dir: " + dir)
	folder_dir = gameDir
	project_folder = gameFolder
	
	return 

func _on_pressed():
	#loadMods()
	## chares new package on the path folder_dir
	#ProjectSettings.load_resource_pack(folder_dir, false)
	ProjectSettings.load_resource_pack(folder_dir,true)
	var temp_dir = folder_dir.split("//")
	var gameName = temp_dir[temp_dir.size()-1]
	gameName = gameName.get_slice(".",0)
	#Debug.log(folder_dir)
	#Debug.log(game_dir)
	#Debug.log(project_folder)
	# TO FIX LOADING GAMES ISSUE
	if gameName.length() > 0:
		Debug.log("res://" + gameName + game_scene_name)
		gameScene = load("res://" + gameName + game_scene_name)
		if gameScene:
			var ActualGame = gameScene.instantiate()
			StartNewGame.emit(ActualGame, project_folder)
			return
	if gameName.length() > 0:
		Debug.log("res://" + gameName + "//Arcademain.tscn")
		gameScene = load("res://" + gameName + "//Arcademain.tscn")
		if gameScene:
			var ActualGame = gameScene.instantiate()
			StartNewGame.emit(ActualGame, project_folder)
			return
	# TEMPORAL FIX FOR TESTING PURPOSES
	if gameName.length() > 0:
		gameScene = load("res://Sequencer//ArcadeMain.tscn")
		if gameScene:
			var ActualGame = gameScene.instantiate()
			StartNewGame.emit(ActualGame, project_folder)
			return
	if gameName.length() > 0:
		gameScene = load("res://Sequencer//Arcademain.tscn")
		if gameScene:
			var ActualGame = gameScene.instantiate()
			StartNewGame.emit(ActualGame, project_folder)
			return
	## loads the newgame on the scene game_dir
	gameScene = load(game_dir)
	Debug.log(gameScene)
	var ActualGame = gameScene.instantiate()
	StartNewGame.emit(ActualGame, project_folder)
	return




func _on_mouse_entered() -> void:
	ShowGameInfo.emit(project_folder)
	return


func _on_mouse_exited() -> void:
	HideGameInfo.emit()
	return
