extends Node2D

signal Inactivy

var thisSessionT
var thisGameT
var timeSinceLastInput = 0.0

var bHasSessionStarted = false
var bHasGameStarted = false

var gameDirection = ""
var DEBUG = true
var Inactivy_time = 300 # 5 minutos

## DEBUG ##
@onready var debug_session_timer: Label = $debug_session_timer
@onready var debug_game_timer: Label = $debug_game_timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thisSessionT = 0
	thisGameT = 0
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## METRICAS RELATED
	if bHasSessionStarted:
		thisSessionT += delta
		
		## INACTIVIDAD RELATED
		if Input.is_anything_pressed():
			timeSinceLastInput = 0
		else:
			timeSinceLastInput += delta
		#if timeSinceLastInput >= 5 * 60: # 5 minutos
		if timeSinceLastInput >= Inactivy_time: # 5 minutos
			Inactivy.emit()
			
	if bHasGameStarted:
		thisGameT += delta
	if DEBUG:
		debug_session_timer.text = "session: " + str(int(thisSessionT))
		debug_game_timer.text = "game: " + str(int(thisGameT))
	return

func startSessionTimer():
	bHasSessionStarted = true
	timeSinceLastInput = 0
	thisSessionT = 0
	return
func endSessionTimer():
	bHasSessionStarted = false
	thisSessionT = 0
	thisGameT = 0
	return
func startGameTimer(in_game_direction):
	bHasGameStarted = true
	timeSinceLastInput = 0
	thisGameT = 0
	gameDirection = in_game_direction
	return
func endGameTimer():
	bHasGameStarted = false
	Debug.log(gameDirection)
	# tiempos.json
	var path = gameDirection
	var file = FileAccess.open(path + "tiempos.json", FileAccess.READ_WRITE)
	var json = file.get_as_text()
	json = JSON.parse_string(json)
	Debug.log(json["tiempo_total"])
	Debug.log(json["numero_usuarios_totales"])
	Debug.log(json)
	json["tiempo_total"] += thisGameT
	json["numero_usuarios_totales"] += 1
	Debug.log(json)
	file.store_string(JSON.stringify(json))
	timeSinceLastInput = 0
	thisGameT = 0
	gameDirection = ""
	return
