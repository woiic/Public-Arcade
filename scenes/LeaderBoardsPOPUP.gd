extends Node2D

@onready var tables_container: GridContainer = $TablesContainer

var parent
var game_dir = "res://main.tscn"

var folder_dir = ""
var project_folder = ""

var tables_folder := "res://imports//"
var gameDir = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("template"):
		tables_folder = OS.get_executable_path().get_base_dir() + "/games/"
	parent = get_parent()
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setTable(gameDir):
	gameDir = gameDir
	var database = SQLite.new()
	database.path= gameDir + "database.db"
	database.open_db()
	if database.query("SELECT *
		FROM LeaderBoards
		ORDER BY score DESC"):
		var scoreData = [] # = database.select_rows("LeaderBoards", "", ["*"])
		for data in database.query_result:
			scoreData.append(data)
		tables_container.setTables(scoreData)
	return


func _on_button_pressed() -> void:
	parent.hideLeaderBoard()
	return
