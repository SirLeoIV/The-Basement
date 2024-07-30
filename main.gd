extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Board").visible = false
	get_node("Welcome Screen").visible = true
	get_node("How to play").visible = false
	get_node("Game over").visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	get_parent().restart()

func _on_how_to_play_pressed():
	get_node("Board").visible = false
	get_node("How to play").visible = true

