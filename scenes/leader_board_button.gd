extends Button

signal OpenLeaderBoard


var database : SQLite

var folder_dir : String 
var project_folder : String
var game_dir = "res://main.tscn"
#var mod_folder := "res://imports/1stExport.zip"

var parent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setText(inText: String):
	text = inText
	return

func setGameDir(gameDir :String, gameFolder :String):
	#Debug.log("folder dir: " + dir)
	folder_dir = gameDir
	project_folder = gameFolder
	return 

func _on_LeaderBoard_down() -> void:
	database = SQLite.new()
	database.path= project_folder + "database.db"
	database.open_db()
	if database.query("SELECT *
		FROM LeaderBoards
		ORDER BY score DESC"):
		var scoreData = []# = database.select_rows("LeaderBoards", "", ["*"])
		for data in database.query_result:
			scoreData.append(data)
			#var scoreData = database.select_rows("LeaderBoards", "", ["*"])
		#database.close_db()
		OpenLeaderBoard.emit(scoreData)
	return
