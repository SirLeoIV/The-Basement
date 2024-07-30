extends Node2D

var game

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Main").visible = false
	var scene = load("res://main.tscn")
	var instance = scene.instantiate(2)
	game = instance
	add_child(game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart():
	remove_child(game)
	var scene = load("res://main.tscn")
	var instance = scene.instantiate(2)
	game = instance
	add_child(game)
