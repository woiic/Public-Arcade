extends Control

@onready var score_text = $ScoreText
@onready var score_number = $ScoreText/ScoreNumber

# Called when the node enters the scene tree for the first time.
func _ready():
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func showScore(in_points: float, max_points: float, delay : float=2):
	show()
	score_text.hide()
	score_number.hide()
	#await(get_tree().create_timer(delay), "timeout")
	await get_tree().create_timer(delay).timeout
	score_number.text = str(in_points)
	score_text.show()
	score_number.show()
	return

func hideScore():
	#score_text.hide()
	#score_number.hide()
	hide()
	return
