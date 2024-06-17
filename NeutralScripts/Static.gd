extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
class PlayerData :
	var id : int
	var name : String
	var image : String
	var faculty : String
	
	func _init(inId: int, inName: String, inImage: String, inFaculty: String):
		id = inId
		name = inName
		image = inImage
		faculty = inFaculty
		return

