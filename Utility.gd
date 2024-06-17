extends Node

enum id_buttons {
	none=0,
	left,
	up,
	right,
	down
}

enum UP_DOWN {
	none=0,
	up,
	down
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class Secuencia :
	var first_half : Array[int]
	var second_half : Array[Array]
	var rng = RandomNumberGenerator.new()
	
	func _init(first_long, second_long):
		var seq_list = []
		for i in range(first_long):
			var new_num = rng.randi_range(1, id_buttons.size()-1)
			first_half.append(new_num)
		var temp_arr1 = []
		var temp_arr2 = []
		for i in range(second_long):
			var new_num1 = rng.randi_range(1, id_buttons.size()-1)
			var new_num2 = rng.randi_range(1, id_buttons.size()-1)
			temp_arr1.append(new_num1)
			temp_arr2.append(new_num2)
		second_half.append(temp_arr1) # [0] UPPER HALF
		second_half.append(temp_arr2) # [0] BOTTOM HALF
		return
	
	# Custom string conversion method
	func _to_string():
		if second_half.size() == 2:
			return "Secuencia:\n" + \
			"primera mitad: " + str(first_half) + '\n' + \
			"segunda mitad: \n" + str(second_half[0]) + "\n" + str(second_half[1])
		elif second_half.size() == 1:
			return "Secuencia:\n" + \
			"primera mitad: " +  str(first_half) + \
			"segunda mitad: " + str(second_half[0])
		else:
			return "Secuencia:\n" + \
			"primera mitad: " +  str(first_half)
	
	func size():
		return first_half.size() + second_half[0].size()
	
	func getId(index, up_down, debug=false):
		if debug:
			Debug.log(index)
			Debug.log(first_half.size())
			Debug.log(second_half.size())
		if first_half.size() > index:
			return first_half[index]
		if second_half[0].size() + first_half.size() > index:
			if up_down == UP_DOWN.up:
				return second_half[0][index-first_half.size()]
			if up_down == UP_DOWN.down:
				return second_half[1][index-first_half.size()]
			else:
				return -1
		return -1
