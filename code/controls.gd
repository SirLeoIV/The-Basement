extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_player():
	return get_parent().get_node("Board").selected_player

func _on_rotate_right_pressed():
	if get_player() != null:
		get_player().rotate_right()


func _on_rotate_left_pressed():
	if get_player() != null:
		get_player().rotate_left()


func _on_move_up_pressed():
	if get_player() != null:
		get_player().move_up()


func _on_move_down_pressed():
	if get_player() != null:
		get_player().move_down()


func _on_move_left_pressed():
	if get_player() != null:
		get_player().move_left()


func _on_move_right_pressed():
	if get_player() != null:
		get_player().move_right()
