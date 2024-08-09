extends Node2D

var pos = Vector2i(-1, -1)
var active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_pos(new_pos: Vector2i):
	pos = new_pos
	set_position(Vector2i(16 + new_pos.x*32, 16 + new_pos.y*32))

func hitting_player(player_pos: Vector2i):
	return abs(player_pos.x - pos.x) + abs(player_pos.y - pos.y) <= 1

func nearest_player(players_dict):
	var result = null
	var distance = 100
	var players = []
	for p in players_dict:
		if !players_dict[p].safe:
			players.append(players_dict[p])
	players.shuffle()
	for player in players:
		var this_distance = abs(player.pos.x - pos.x) + abs(player.pos.y - pos.y)
		if this_distance < distance:
			distance = this_distance
			result = player
	return result

func move_step_to_player(player_pos: Vector2i):
	if abs(player_pos.x - pos.x) > abs(player_pos.y - pos.y):
		var inc = 1
		if player_pos.x < pos.x:
			inc = -1
		set_pos(Vector2i(pos.x + inc, pos.y))
	else:
		var inc = 1
		if player_pos.y < pos.y:
			inc = -1
		set_pos(Vector2i(pos.x, pos.y + inc))


