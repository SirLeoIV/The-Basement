extends Node2D

const Item = preload("res://code/board/Item.gd")
const Player = preload("res://code/board/player.gd")

var players = {}
var items = {}
var monsters = []
var selected_player
var moves = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	init_game()

func init_game():
	var p1 = get_node("Player 1")
	players["Player 1"] = p1
	p1.set_sign(get_parent().get_node("Info Explorer"))
	p1.light_strength = 4
	p1.set_player_id(1)
	p1.set_pos(Vector2i(7, 5))
	p1.set_orientation(Player.directions.LEFT)
	p1.prev_pos = p1.pos
	p1.get_node("Hit Light").visible = false
	p1.sign.get_node("Dead").visible = false
	p1.sign.get_node("Selected").visible = false
	p1.sign.get_node("Safe").visible = false
	
	var p2 = get_node("Player 2")
	players["Player 2"] = p2
	p2.set_sign(get_parent().get_node("Info Guardian"))
	p2.set_player_id(2)
	p2.set_pos(Vector2i(7, 4))
	p2.set_orientation(Player.directions.DOWN)
	p2.prev_pos = p2.pos
	p2.get_node("Hit Light").visible = false
	p2.sign.get_node("Dead").visible = false
	p2.sign.get_node("Selected").visible = false
	p2.sign.get_node("Safe").visible = false
	
	var p3 = get_node("Player 3")
	players["Player 3"] = p3
	p3.set_sign(get_parent().get_node("Info Scolar"))
	p3.set_player_id(3)
	p3.set_pos(Vector2i(6, 4))
	p3.set_orientation(Player.directions.LEFT)
	p3.prev_pos = p3.pos
	p3.get_node("Hit Light").visible = false
	p3.sign.get_node("Dead").visible = false
	p3.sign.get_node("Selected").visible = false
	p3.sign.get_node("Safe").visible = false
	
	set_item_gray(get_parent().get_node("Items-Sign/Gems"))
	set_item_gray(get_parent().get_node("Items-Sign/Recipe"))
	set_item_gray(get_parent().get_node("Items-Sign/Item-bottle"))
	
	# place items on board
	var glass_item = get_node("Item-Gems")
	items["Glass"] = glass_item
	glass_item.type = Item.types.GLASS
	var recipe_item = get_node("Item-Recipe")
	items["Recipe"] = recipe_item
	recipe_item.type = Item.types.RECIPE
	var bottle_item = get_node("Item-bottle")
	items["Bottle"] = bottle_item
	bottle_item.type = Item.types.BOTTLE
	
	monsters.append(get_node("Monster"))
	monsters[0].set_pos(Vector2i(5, 6))
	monsters[0].visible = false
	#monsters[0].visible = true # TODO
	
	place_items_and_monster()
	update_items()
	get_parent().get_node("Controls").visible = false
	
	print("ready")
	

func place_items_and_monster():
	var rooms = [1, 2, 3, 4, 5, 6, 7]
	rooms.shuffle()
	var index = 0
	for i in items:
		items[i].set_pos(random_spot_in_room(rooms[index]))
		index += 1
	for monster in monsters:
		monster.set_pos(random_spot_in_room(rooms[index]))
		index += 1

func random_spot_in_room(room: int):
	if room == 1:
		return (Vector2i(randi_range(0,4), randi_range(0,2)))
	if room == 2:
		return (Vector2i(randi_range(0,4), randi_range(3,6)))
	if room == 3:
		return (Vector2i(randi_range(0,4), randi_range(7,9)))
	if room == 4:
		return (Vector2i(randi_range(8,12), randi_range(0,3)))
	if room == 5:
		return (Vector2i(randi_range(8,12), randi_range(4,7)))
	if room == 6:
		return (Vector2i(randi_range(8,9), randi_range(8,9)))
	if room == 7:
		return (Vector2i(randi_range(10,12), randi_range(8,9)))
	return Vector2i(0,0)

func update_items():
	for i in items:
		items[i].visible = false
		#items[i].visible = true # TODO
	for p in players:
		for i in items:
			var tiles = players[p].get_lit_area()
			for tile in tiles:
				if items[i].hit(tile):
					items[i].visible = true

func place_player(player_name: String):
	pass

func select(tile: Vector2i):
	selected_player = null
	get_parent().get_node("Controls").visible = false
	for i in players:
		var player = players[i]
		if player.pos.x == tile.x && player.pos.y == tile.y:
			player.selected = true
			player.sign.get_node("Selected").visible = true
			selected_player = player
			get_parent().get_node("Controls").visible = true
		else:
			player.selected = false
			player.sign.get_node("Selected").visible = false

func make_move():
	increment_moves()
	get_node("FloorGrid").selected = selected_player.pos
	check_items()
	for p in players:
		players[p].get_node("Hit Light").visible = false
	check_monsters()
	check_players()
	select(get_node("FloorGrid").selected)
	
	if players.size() == 0:
		visible = false
		get_parent().get_node("Game over").visible = true
	else:
		var game_running = false
		for p in players:
			if !players[p].safe:
				game_running = true
		if !game_running:
			show_winning_screen()

func increment_moves(i:int = 1):
	moves = min(999, moves + i)
	get_parent().get_node("Moves-Sign/MovesLabel").text = "Moves: " + str(moves)

func check_items():
	for i in items:
		var item = items[i]
		if item.hit(selected_player.pos):
			item.retrieved = true
			item.set_pos(Vector2i(-1, -1))
			if item.type == Item.types.BOTTLE:
				set_item_color(get_parent().get_node("Items-Sign/Item-bottle"))
			elif item.type == Item.types.GLASS:
				set_item_color(get_parent().get_node("Items-Sign/Gems"))
			elif item.type == Item.types.RECIPE:
				set_item_color(get_parent().get_node("Items-Sign/Recipe"))
	update_items()

func check_monsters():
	for monster in monsters:
		monster.visible = false
		check_monster_visibility(monster)
		if monster.visible == false:
			check_monster_attack(monster)

func check_monster_visibility(monster):
	for p in players:
		var player = players[p]
		for tile in player.get_lit_area():
			if monster.pos.x == tile.x && monster.pos.y == tile.y:
				monster.visible = true
				player.sanity = player.sanity - 3
				player.update_sign()

func check_monster_attack(monster):
	var monster_hits = false
	var player_hitting = null
	for p in players:
		if monster.hitting_player(players[p].prev_pos):
			monster_hits = true
			player_hitting = players[p]
	if monster_hits:
		perform_monster_hit(monster, player_hitting)
	else:
		monster_move_to_nearest_player(monster)

func perform_monster_hit(monster, player_hitting):
	if monster.hitting_player(player_hitting.pos):
		player_hitting.health = player_hitting.health - 1
		player_hitting.update_sign()
		player_hitting.get_node("Hit Light").visible = true

func monster_move_to_nearest_player(monster):
	var target = monster.nearest_player(players)
	var rng = randi_range(0, 2)
	for i in rng:
		if !monster.hitting_player(target.pos):
			monster.move_step_to_player(target.prev_pos)

func check_players():
	for p in players:
		var player = players[p]
		player.sanity = min(player.max_sanity, player.sanity + 1)
		player.set_pos(player.pos)
		player.update_sign()
		if player.pos.x == 7 && player.pos.y == 2: # top of the stairs
			player_exits_basement(player)
		else:
			if player.sanity <= 0:
				players.erase(p)
				player_goes_insane(player)
			if player.health <= 0:
				players.erase(p)
				player_dies(player)

func player_exits_basement(player):
	player.visible = false
	player.set_pos(Vector2i(-1, -1))
	player.safe = true
	player.sign.get_node("Selected").visible = false
	player.sign.get_node("Safe").visible = true

func player_goes_insane(player):
	var pos = player.pos
	player.visible = false
	player.sign.get_node("Selected").visible = false
	player.sign.get_node("Dead").visible = true
	var Monster = load("res://code/board/monster.tscn")
	var new_monster = Monster.instantiate()
	monsters.append(new_monster)
	add_child(new_monster)
	new_monster.set_pos(pos)
	new_monster.visible = false

func player_dies(player):
	var pos = player.pos
	player.visible = false
	player.sign.get_node("Selected").visible = false
	player.sign.get_node("Dead").visible = true
	var Skull = load("res://code/board/skull.tscn")
	var skull = Skull.instantiate()
	add_child(skull)
	skull.set_position(player.position)

func show_winning_screen():
	visible = false
	var win_sreen = get_parent().get_node("Winning Screen")
	win_sreen.visible = true
	win_sreen.moves = moves
	win_sreen.players = players.size()
	var items_retrieved = 0
	for i in items:
		if items[i].retrieved:
			items_retrieved += 1
	win_sreen.items = items_retrieved
	win_sreen.calculate_score()

func set_item_gray(item: Sprite2D):
	item.modulate = Color(0,0,0)
	item.get_node("Light").visible = false

func set_item_color(item: Sprite2D):
	item.modulate = Color(1,1,1)
	item.get_node("Light").visible = true

