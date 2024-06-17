extends Node2D

var MainScene

var client = StreamPeerTCP.new()
var bIsConnected = false
var connectingDelay = 120
var timeSinceLastConection = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	return

# :------------------------------ Player Data Class -----------------------------: #


class PlayerData :
	var id : int
	var name : String
	var image : String
	var faculty : String
	var guest : bool
		
	func _init(inId: int, inName: String, inImage: String, inFaculty: String, bIsGuest = false):
		id = inId
		name = inName
		image = inImage
		faculty = inFaculty
		guest = bIsGuest
		return
	
	# Custom string conversion method
	func _to_string():
		return "My Player Data - Name: " + str(name) + ", image address: " + str(image) + \
			", faculty address: " + str(faculty) + ", is guest: " + str(guest)



# :------------------------------ v1.0 Methods that gets info from the MainScene -----------------------------: #

func get_PlayerData():
	var player_data : PlayerData
	player_data = MainScene.givesToGlobal_PlayerData()
	return player_data

func get_BestScore():
	var new_score = MainScene.givesToGlobal_BestScore()
	return new_score

func get_LeaderBoard():
	var LeaderBoard : String
	#LeaderBoard = "sebicho 100 \n vicente 200"
	#return LeaderBoard
	return

# :------------------------------ v1.0 Methods that gives info to the MainScene -----------------------------: #

# Envia el nuevo puntaje al MainScne para quelo guarde
func game_over(in_points :float):
	Debug.log("guardado puntajes")
	var bIsBestScore = MainScene.setsFromGlobal_NewBestScore(in_points)
	Debug.log(bIsBestScore)
	return bIsBestScore	

# :------------------------------ v0.1 FeedBack global Methods -----------------------------: #

func showFeedBack():
	Debug.log("mostrando feedback")
	return MainScene.showFeedBackScene()

func hideFeedBack():
	MainScene.hideFeedBackScene()
	return

# :------------------------------ v0.1 LeaderBoard global Methods -----------------------------: #


func showLeaderBoard():
	Debug.log("mostrando local LeaderBoards")
	return MainScene.showLeaderBoard()

func hideLeaderBoard():
	MainScene.hideLeaderBoard()
	return

# :------------------------------ v0.1 General global Methods -----------------------------: #

func load_texture(obj, path):
	var img = Image.new()
	img.load(path)
	var texture = ImageTexture.create_from_image(img)
	#texture.create_from_image(img)
	obj.texture = texture

func closeGame():
	MainScene.EndGame(MainScene.main_game)
	return
# :------------------------------ v0.1 Time Calculation Methods -----------------------------: #

func diferenciaDeTiempos_dias(dict1, dict2):
	var dia1 = dict1["day"]
	var mes1 = dict1["month"]
	var ano1 = dict1["year"]
	var dia2 = dict2["day"]
	var mes2 = dict2["month"]
	var ano2 = dict2["year"]
	var diferencia_dias = int(ano2)*365 + int(mes2) * 30 + int(dia2) - (int(ano1)*365 + int(mes1) * 30 + int(dia1))
	return diferencia_dias
