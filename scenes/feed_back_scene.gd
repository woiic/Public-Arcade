extends Node2D

signal onFeedBackSave(bIfSaved, text)

@onready var label: Label = $Control/Label
@onready var label_2: Label = $Control/Label2
@onready var text_edit: TextEdit = $Control/TextEdit
@onready var button: Button = $Control/Enter
@onready var cerrar: Button = $Control/Cerrar

var gamePath = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = gamePath
	pass


func _on_button_pressed() -> void:
	onFeedBackSave.emit(true, text_edit.text)
	text_edit.text = ""
	return
	


func _on_cerrar_pressed() -> void:
	onFeedBackSave.emit(false, "text_edit.text")
	text_edit.text = ""
	return
