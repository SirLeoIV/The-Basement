@tool
extends Node2D

enum directions {LEFT, RIGHT, UP, DOWN}
var pos = Vector2i(1, 2)
var prev_pos = Vector2i(1, 2)
var orientation = directions.UP
var light_strength: int = 3
var selected = true
var safe = false

var sanity: int = 10
var max_sanity: int = 10

var health: int = 10
var max_health: int = 10

var sign: Sprite2D

var width = 13
var height = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	#set_pos(pos)
	set_player_id(get_meta("player_id"))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_player_id(id: int):
	get_node("Indie-Hat").visible = false
	get_node("Military-Hat").visible = false
	get_node("Bowler-Hat").visible = false
	get_node("PointLight2D").visible = false
	get_node("PointLight2D-strong").visible = false
	if id == 1:
		get_node("Indie-Hat").visible = true
		get_node("PointLight2D-strong").visible = true
	elif id == 2:
		get_node("Military-Hat").visible = true
		get_node("PointLight2D").visible = true
		max_health = 14
		health = 14
		max_sanity = 6
		sanity = 6
	else:
		get_node("Bowler-Hat").visible = true
		get_node("PointLight2D").visible = true
		max_health = 6
		health = 6
		max_sanity = 14
		sanity = 14
	if sign != null: sign.update(sanity, health, max_sanity, max_health)
#	update_sign()


func set_sign(sprite: Sprite2D):
	sign = sprite

func update_sign():
	if sign != null:
		sign.get_node("Sanity").text = "SANITY: " + str(sanity) + "/" + str(max_sanity)
		sign.get_node("Health").text = "HEALTH: " + str(health) + "/" + str(max_health)

func get_lit_area():
	var area = [pos]
	var x_increase = 0
	var y_increase = 0
	if orientation == directions.UP:
		y_increase = -1
	elif orientation == directions.DOWN:
		y_increase = 1
	elif orientation == directions.LEFT:
		x_increase = -1
	elif orientation == directions.RIGHT:
		x_increase = 1
	var no_wall = true
	for i in light_strength:
		if no_wall:
			var next_tile = Vector2i(area[i].x + x_increase, area[i].y + y_increase)
			if is_wall_in_between(area[i], next_tile):
				no_wall = false
			else:
				area.append(Vector2i(area[i].x + x_increase, area[i].y + y_increase))
	return area

func rotate_right():
	if orientation == directions.UP:
		set_orientation(directions.RIGHT)
	elif orientation == directions.RIGHT:
		set_orientation(directions.DOWN)
	elif orientation == directions.DOWN:
		set_orientation(directions.LEFT)
	elif orientation == directions.LEFT:
		set_orientation(directions.UP)
	get_parent().make_move()

func rotate_left():
	if orientation == directions.UP:
		set_orientation(directions.LEFT)
	elif orientation == directions.LEFT:
		set_orientation(directions.DOWN)
	elif orientation == directions.DOWN:
		set_orientation(directions.RIGHT)
	elif orientation == directions.RIGHT:
		set_orientation(directions.UP)
	get_parent().make_move()

func set_orientation(new_orientation):
	orientation = new_orientation
	prev_pos = pos
	if orientation == directions.UP:
		get_node("PointLight2D").set_rotation_degrees(0)
		get_node("PointLight2D-strong").set_rotation_degrees(0)
	elif orientation == directions.DOWN:
		get_node("PointLight2D").set_rotation_degrees(180)
		get_node("PointLight2D-strong").set_rotation_degrees(180)
	elif orientation == directions.LEFT:
		get_node("PointLight2D").set_rotation_degrees(270)
		get_node("PointLight2D-strong").set_rotation_degrees(270)
	elif orientation == directions.RIGHT:
		get_node("PointLight2D").set_rotation_degrees(90)
		get_node("PointLight2D-strong").set_rotation_degrees(90)

func move_up():
	var new_pos = Vector2i(pos.x, pos.y - 1)
	if can_move_there(new_pos):
		set_pos(new_pos)
		get_parent().get_node("FloorGrid").selected = pos
		get_parent().make_move()
		return true
	return false
	
func move_down():
	var new_pos = Vector2i(pos.x, pos.y + 1)
	if can_move_there(new_pos):
		set_pos(new_pos)
		get_parent().get_node("FloorGrid").selected = pos
		get_parent().make_move()
		return true
	return false

func move_right():
	var new_pos = Vector2i(pos.x + 1, pos.y)
	if can_move_there(new_pos):
		set_pos(new_pos)
		get_parent().get_node("FloorGrid").selected = pos
		get_parent().make_move()
		return true
	return false

func move_left():
	var new_pos = Vector2i(pos.x - 1, pos.y)
	if can_move_there(new_pos):
		set_pos(new_pos)
		get_parent().get_node("FloorGrid").selected = pos
		get_parent().make_move()
		return true
	return false

func set_pos(new_pos: Vector2i):
	prev_pos = pos
	pos = new_pos
	set_position(Vector2i(16 + new_pos.x*32, 16 + new_pos.y*32))

func can_move_there(new_pos):
	if is_wall_in_between(pos, new_pos):
		return false
	
	var players = get_parent().players
	for p in players:
		if players[p].pos.x == new_pos.x && players[p].pos.y == new_pos.y:
			return false
	return true

func is_wall_in_between(pos1: Vector2i, pos2: Vector2i):
	if !(pos2.x < width && pos2.x >= 0 && pos2.y < height && pos2.y >= 0):
		return true
	if [0, 2, 3, 4, 6, 7, 9].has(pos1.y):
		if ((pos1.x == 4 && pos2.x == 5) 
		|| (pos1.x == 5 && pos2.x == 4)):
			return true
	if [2, 3].has(pos1.y):
		if ((pos1.x == 6 && pos2.x == 7) 
		|| (pos1.x == 7 && pos2.x == 6)):
			return true
	if [0, 2, 3, 4, 5, 6, 8, 9].has(pos1.y):
		if ((pos1.x == 7 && pos2.x == 8) 
		|| (pos1.x == 8 && pos2.x == 7)):
			return true
	if [8, 9].has(pos1.y):
		if ((pos1.x == 9 && pos2.x == 10) 
		|| (pos1.x == 10 && pos2.x == 9)):
			return true
	if [7].has(pos1.x):
		if ((pos1.y == 1 && pos2.y == 2) 
		|| (pos1.y == 2 && pos2.y == 1)):
			return true
	if [0, 2, 3, 4].has(pos1.x):
		if ((pos1.y == 2 && pos2.y == 3) 
		|| (pos1.y == 3 && pos2.y == 2)):
			return true
	if [8, 9, 12].has(pos1.x):
		if ((pos1.y == 3 && pos2.y == 4) 
		|| (pos1.y == 4 && pos2.y == 3)):
			return true
	if [0, 2, 3, 4].has(pos1.x):
		if ((pos1.y == 6 && pos2.y == 7) 
		|| (pos1.y == 7 && pos2.y == 6)):
			return true
	if [8, 11, 12].has(pos1.x):
		if ((pos1.y == 7 && pos2.y == 8) 
		|| (pos1.y == 8 && pos2.y == 7)):
			return true
	return false
