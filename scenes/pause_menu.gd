extends Control

signal return_mm

@onready var pause_title = $pause_title
@onready var main_menu_bttn = $main_menu_bttn
@onready var continue_bttn = $continue_bttn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_main_menu_bttn_pressed():
	return_mm.emit()
	pass # Replace with function body.
