extends CanvasLayer

enum State {
Idle = 0,
WaitingSession,
ChossingGame,
InGame,
OnLeaderBoards,
}

var ActualState;
var PreviousState;
@onready var title = $Title
@onready var titleButton = $Title/Button
@onready var sessions_button: Button = $Title/SessionsButton

@onready var game_list_scene = $GameListScene
@onready var pause_container = $pause_container
@onready var game_overlay = $GameOverlay
@onready var session_handler = $SessionHandler
@onready var leader_boards_scene: Control = $LeaderBoards_scene
@onready var close_session: Button = %CloseSession
@onready var profile: Control = %Profile

@onready var time_manager: Node2D = %TimeManager

@onready var debug = $Debug
@onready var debug_button: Button = $DebugButton
@onready var session_debug: Label = $SessionDebug

@onready var sprite_2d: Sprite2D = $Sprite2D

## feedback things
# conexion python
@onready var leader_boards: Button = $Title/LeaderBoards
@onready var client: Node2D = $client
# obtención y guardado de feedback
@onready var feed_back: Node2D = $FeedBack
var bIsShowingFeedBackScene = false

@onready var leader_boards_popup: Node2D = %LeaderBoardsPOPUP
var bIsShowingLBLScene = false
## Game Things

## game database

var database : SQLite

var bon_pause = false
var this_game_score : float = 0
var max_game_score : float = 0
var this_user = "hola2"

## Players data

var P1_PlayerData = Global.PlayerData.new(0, "", "", "")
#var this_PlayerData # Actual player data

## Directions

var gamePath : String = ""

#var simultaneous_scene = preload("res://scenes/game_selector_scene.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	ActualState = State.Idle
	PreviousState = State.Idle
	game_list_scene.hide()
	game_list_scene.parent = self
	pause_container.hide()
	game_overlay.hide()
	session_handler.parent = self
	session_handler.hide()
	leader_boards_scene.hide()
	close_session.hide()
	title.show()
	feed_back.hide()
	leader_boards_popup.hide()
	#time_manager.hide()
	# PlayerData(inId: int, inName: String, inImage: String, inFaculty: String):
	#this_PlayerData = Global.PlayerData.new(0, "loiic", "link/to/image", "FCFM")
	P1_PlayerData = Global.PlayerData.new(0, "", "", "")
	get_parent().get_child(0).MainScene = self
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match ActualState:
		State.Idle:
			# First change state actions
			if PreviousState != ActualState:
				PreviousState = ActualState
				profile.show()
				game_list_scene.hide()
				pause_container.hide()
				session_handler.hide()
				leader_boards_scene.hide()
				close_session.hide()
				sessions_button.show()
				if P1_PlayerData.name != "":
					close_session.show()
					sessions_button.hide()
				title.show()
			debug.text = "Idle State"
		State.WaitingSession:
			# First change state actions
			if PreviousState != ActualState:
				profile.show()
				title.hide()
				game_list_scene.hide()
				session_handler.show()
				leader_boards_scene.hide()
				close_session.hide()
				PreviousState = ActualState
				onWaitingSession()
			debug.text = "WaitingSession State"
		State.ChossingGame:
			if PreviousState != ActualState:
				profile.show()
				title.hide()
				game_list_scene.show()
				session_handler.hide()
				leader_boards_scene.hide()
				close_session.hide()
				PreviousState = ActualState
			debug.text = "ChossingGame State"
		State.InGame:
			if PreviousState != ActualState:
				profile.hide()
				PreviousState = ActualState
			debug.text = "InGame State  ---  " + gamePath
			if !bIsShowingFeedBackScene and !bIsShowingLBLScene and Input.is_action_just_pressed("escape"):
				Debug.log("saliendo del juego")
				var main_game = $Main
				if main_game:
					EndGame(main_game)
			if bIsShowingFeedBackScene:
				feed_back.show()
				feed_back.move_to_front()
			if !bIsShowingFeedBackScene:
				feed_back.hide()
			if bIsShowingLBLScene:
				leader_boards_popup.show()
				#leader_boards_popup.setTable(gamePath)
				leader_boards_popup.move_to_front()
			if !bIsShowingLBLScene:
				leader_boards_popup.hide()
		State.OnLeaderBoards:
			if PreviousState != ActualState:
				profile.show()
				title.hide()
				game_list_scene.hide()
				session_handler.hide()
				leader_boards_scene.show()
				close_session.hide()
				PreviousState = ActualState
			debug.text = "ChossingGame State"
	######################## --- DEBUG --- ########################
	session_debug.text = P1_PlayerData._to_string()
	return

# :------------------------------ State Machine functions -----------------------------: #

func returnToMainMenu():
	ActualState = State.Idle
	return

# :------------------------------ Methods work with the user info session_handler -----------------------------: #

# aca tengo que enviar el rut al cliente y tengo q esperar respuesta
func getUserInfoFromAPI(inRUT):
	#Debug.log("rut sended")
	var playerInfo = await client.requestPlayerInfo(inRUT)
	#Debug.log(playerInfo)
	return playerInfo


func _on_close_session_pressed() -> void:
	sessions_button.show()
	close_session.hide()
	closeSession()
	return


## Sessions functions Functional

func _on_sessions_button_pressed() -> void:
	ActualState = State.WaitingSession
	return


func _on_guest_session(guest_data: Variant) -> void:
	P1_PlayerData = guest_data
	profile.setProfile(P1_PlayerData.name, P1_PlayerData.image)
	ActualState = State.ChossingGame
	time_manager.startSessionTimer()
	return


func _on_player_session(player_data: Variant) -> void:
	P1_PlayerData = player_data
	profile.setProfile(P1_PlayerData.name, P1_PlayerData.image)
	time_manager.startSessionTimer()
	ActualState = State.ChossingGame
	return


func closeSession():
	P1_PlayerData = Global.PlayerData.new(0, "", "", "")
	profile.removeProfile()
	time_manager.endSessionTimer()
	return

func closeSessionAndReturnToMM():
	P1_PlayerData = Global.PlayerData.new(0, "", "", "")
	profile.removeProfile()
	time_manager.endSessionTimer()
	ActualState = State.Idle
	return


## Game Choosing functions

func _btn_going_to_games() -> void:
	if P1_PlayerData.name == "": # no hay sesion abierta
		ActualState = State.WaitingSession
	else: # hay sesion abierta
		ActualState = State.ChossingGame
		game_list_scene.show()
		title.hide()
	return

func _on_pause_container_return_mm():
	var main_game = $Main
	if main_game:
		main_game.queue_free()
		game_list_scene.show()

func _on_game_list_scene_game_selected(folder_direction):
	ActualState = State.InGame
	gamePath = folder_direction
	feed_back.gamePath = gamePath
	time_manager.startGameTimer(folder_direction)
	game_list_scene.hide()
	return

func EndGame(actualGame):
	##TODO: remover de mejor forma el juego, o ver otro metodo más seguro talves
	actualGame.queue_free()
	game_list_scene.show()
	ActualState = State.ChossingGame
	time_manager.endGameTimer()
	#hideScore()
	return

func _on_leaderboard_selected() -> void:
	return

func _on_leader_boards_button_down() -> void:
	ActualState = State.OnLeaderBoards
	return

func _on_leader_boards_scene_back_to_menu() -> void:
	ActualState = State.Idle
	return

# :------------------------------ Methods for first frame of the state -----------------------------: #

# esperando tarjeta
func onWaitingSession():
	# mandar mensaje a python de que espere info de la tarjeta
	client.notify_card_waiting()
	return

# :------------------------------ Methods to interact with Mediador -----------------------------: #

func give_PlayerData():
	#return this_PlayerData
	return P1_PlayerData

# :- Feedback -: #
func showFeedBackScene():
	Debug.log("mostrando feedback-popup")
	var temp_database : SQLite
	temp_database = SQLite.new()
	var playerName = P1_PlayerData.name
	# verificar si el usuario ya entrego feedback
	temp_database.path= gamePath + "hasFeedback.db"
	temp_database.open_db()
	var GivenArr = temp_database.select_rows("hasFeedBack", "nombre='" + playerName + "'", ["hasGive"])
	temp_database.close_db()
	if GivenArr.size() > 0:
		var bhasGivenFeed = GivenArr[0]["hasGive"]
		if bhasGivenFeed:
			return false
		else:
			bIsShowingFeedBackScene = true
			return true
	elif GivenArr.size() == 0: # nuevo usuario
		bIsShowingFeedBackScene = true
		return true

func hideFeedBackScene():
	bIsShowingFeedBackScene = false
	return

# Hide feedback notification
func _on_feed_back_on_feed_back_save(bIfSaved: Variant, text: Variant) -> void:
	if bIfSaved:
		var newFeed = str(text)
		Debug.log(newFeed)
		saveFeedBack(newFeed)
		hideFeedBackScene()
	else:
		hideFeedBackScene()
	return

func saveFeedBack(newFeed):
	var temp_database : SQLite
	temp_database = SQLite.new()
	var playerName = P1_PlayerData.name
	# añadir al usuario de la lista de feedback entregado
	temp_database.path= gamePath + "hasFeedback.db"
	temp_database.open_db()
	var GivenArr = temp_database.select_rows("hasFeedBack", "nombre='" + playerName + "'", ["hasGive"])
	Debug.log(GivenArr)
	if GivenArr.size() > 0:
		var bhasGivenFeed = GivenArr[0]["hasGive"]
		if bhasGivenFeed:
			#Debug.log("es bool")
			temp_database.close_db()
			return 
		else:
			#Debug.log("no es bool")
			temp_database.update_rows("hasFeedBack", "nombre='" + playerName + "'", {"hasGive=": true})
			temp_database.close_db()
	else:
		var data2 = {
			"nombre": playerName,
			"tiempo": int(-1),
			"hasGive": true
			}
		temp_database.insert_row("hasFeedBack", data2)
		temp_database.close_db()
	
	# guardar feedback
	temp_database.path= gamePath + "feedback.db"
	temp_database.open_db()
	var data1 = {
		"text": newFeed
		}
	temp_database.insert_row("FeedBack", data1)
	temp_database.close_db()
	return

# :------------------------------ Local LeaderBoards Related Methods -----------------------------: #

func showLeaderBoard():
	Debug.log("mostrando leaderboards-popup")
	leader_boards_popup.setTable(gamePath)
	bIsShowingLBLScene = true
	return

func hideLeaderBoard():
	bIsShowingLBLScene = false
	return


# :------------------------------ Points Related Methods -----------------------------: #



func givesToGlobal_PlayerData():
	return P1_PlayerData

func givesToGlobal_BestScore():
	var playerName = P1_PlayerData.name
	database = SQLite.new()
	database.path= gamePath + "database.db"
	database.open_db()
	#var dab = database.select_rows("players", "name=="+"'asd'", "*")
	var scoreData = database.select_rows("LeaderBoards", "name='" + playerName+ "'", ["score"])
	if scoreData.size() > 0:
		return scoreData[0]["score"]
	else:
		return 0

func setsFromGlobal_NewBestScore(inPoints):
	var bIsNewScore=false
	var playerName = P1_PlayerData.name
	database = SQLite.new()
	database.path= gamePath + "database.db"
	database.open_db()
	var score = database.select_rows("LeaderBoards", "name='" + playerName + "'", ["score"])
	if score.size() > 0:
		var newScore = score[0]["score"]
		if inPoints > newScore:
			database.update_rows("LeaderBoards", "name='" + playerName + "'", {"score=": int(inPoints)})
			database.close_db()
			return true
		database.close_db()
		return false
	else:
		var data = {
		"name": playerName,
		"score": inPoints
		}
		database.insert_row("LeaderBoards", data)
		database.close_db()
		return true
	


# TODO: cambiar nombre a algo que tenga que ver con el paso de datos desde juego a arcade y que con
#		argumentos extra se hagan distintas acciones

#func showScore(in_points: float, in_delay: float=0):
#	saveScore(in_points)
#	game_overlay.showScore(in_points, max_game_score, in_delay)
#	game_overlay.show()
#	return

#func hideScore():
#	game_overlay.hideScore()
#	return

# DEPRECATED FOR PREVIOUS LEADERBOARD USAGE

func gameOver(in_points: float):
	Debug.log("3")
	Debug.log(in_points)
	return

func saveScore(in_points: float):
	Debug.log("4")
	this_game_score = in_points
	if in_points > max_game_score:
		max_game_score = in_points
		
	var file = FileAccess.open("res://LeaderBoards/test.txt", FileAccess.READ)
	var content = file.get_as_text()
	#Debug.log(content)
	file.close()
	var file2 = FileAccess.open("res://LeaderBoards/test.txt", FileAccess.WRITE)
	var new_scores = save_user_score(content, this_user, max_game_score)
	#file2.store_string(content)
	Debug.log(new_scores)
	file2.store_string(new_scores)
	file2.close()
	return

func search_user_score(search_string : String, user_name : String):
	Debug.log("5")
	var linelist = search_string.split("\n")
	for line in linelist:
		var words = line.split(" ")
		if words[0] == user_name:
			return int(words[1])
	return 0

func save_user_score(search_string : String, user_name : String, top_score : int):
	Debug.log("6")
	var linelist = search_string.split("\n")
	var wordslist = []
	var all_lines = ""
	for line in linelist:
		var words = line.split(" ")
		if words[0] == user_name:
			words[1] = str(top_score)
		wordslist.append_array(words)
	var count = 0
	for word in wordslist:
		if count % 2 == 0:
			all_lines += str(word) + " "
		else:
			all_lines += str(word) + "\n"
		count+=1
	return all_lines

func save(content):
	Debug.log("7")
	var file = FileAccess.open("res://LeaderBoards/test.txt", FileAccess.WRITE)
	file.store_string(content)

func load():
	Debug.log("8")
	var file = FileAccess.open("res://LeaderBoards/test.txt", FileAccess.READ)
	var content = file.get_as_text()
	return content

# :------------------------------ TIME MANAGING -----------------------------: #


## inactividad
func _on_time_manager_inactivy() -> void:
	closeSessionAndReturnToMM()
	return

# :------------------------------ DEBUG -----------------------------: #


func _on_debug_button_pressed() -> void:
	Global.get_PlayerData()
	if P1_PlayerData:
		Global.load_texture(sprite_2d, P1_PlayerData.image)

