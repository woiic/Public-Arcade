extends GridContainer

@onready var names_container: VBoxContainer = %NamesContainer
@onready var points_container: VBoxContainer = %PointsContainer
@onready var info_container: VBoxContainer = %InfoContainer

var names_containerPosLastFrame = Vector2(0,0)
var points_containerPosLastFrame = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if names_containerPosLastFrame != names_container.position:
		#names_containerPosLastFrame = names_container.position
		#points_containerPosLastFrame = names_containerPosLastFrame
		#points_container.position = names_container.position
	#if points_containerPosLastFrame != points_container.position:
		#points_containerPosLastFrame = points_container.position
		#points_containerPosLastFrame = points_containerPosLastFrame
		#names_container.position = points_container.position
	return

func setTables(inTable: Array) -> void:
	#for n in names_container.get_children():
		#names_container.remove_child(n)
		#n.queue_free()
	#for n in points_container.get_children():
		#points_container.remove_child(n)
		#n.queue_free()
	#for data in inTable:
		#var newName = Label.new()
		#newName.text = data["name"]
		#names_container.add_child(newName)
		#var newPoints = Label.new()
		#newPoints.text = str(data["score"])
		#points_container.add_child(newPoints)
	for n in info_container.get_children():
		info_container.remove_child(n)
		n.queue_free()
	for data in inTable:
		var newCont = HBoxContainer.new()
		info_container.add_child(newCont)
		var newName = Label.new()
		newName.text = data["name"]
		newName.clip_text = true
		newName.custom_minimum_size.x = 300
		var newPoints = Label.new()
		newPoints.text = str(data["score"])
		newName.clip_text = true
		newPoints.custom_minimum_size.x = 300
		newCont.add_child(newName)
		newCont.add_child(newPoints)
	return
