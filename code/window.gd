extends Node2D

var game

#var Scene = preload("res://main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("Main").visible = false
	#var scene = load("res://main.tscn")
	#var instance = Scene.instantiate(2)
	#game = instance
	#add_child(game)
	
	game = get_node("Main")
	restart()

func restart():
	remove_child(game)
	# print(get_children())
	var Scene = load("res://code/main.tscn")
	# print(Scene)
	var instance = Scene.instantiate()
	# print(instance)
	game = instance
	add_child(game)
