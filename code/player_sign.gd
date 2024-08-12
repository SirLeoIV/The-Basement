@tool
extends Sprite2D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Desciption").visible = false
	var id = get_meta("player_id")
	if id == null:
		print("...")
	get_node("Avatar Explorer").visible = false
	get_node("Avatar Guardian").visible = false
	get_node("Avatar Scolar").visible = false
	if id == 1:
		get_node("Avatar Explorer").visible = true
		get_node("Desciption/Label").text = "     The explorer! \nLeader of this adventure. \nHas a strong flashlight."
	if id == 2:
		get_node("Avatar Guardian").visible = true
		get_node("Desciption/Label").text = "     The Guardian! \nStrong muscels. \nWeak mind."
	if id == 3:
		get_node("Avatar Scolar").visible = true
		get_node("Desciption/Label").text = "     The scholar! \nKnows things \nDo not leave him alone!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_player(player):
	self.player = player

func update():
	update_stats(player.sanity, player.health, player.max_sanity, player.max_health, player.item)

func update_stats(sanity: int, health: int, max_sanity: int, max_health: int, item: bool):
	get_node("Sanity").text = "SANITY: " + str(sanity) + "/" + str(max_sanity)
	get_node("Health").text = "HEALTH: " + str(health) + "/" + str(max_health)
	if item: get_node("Item").text = "ITEM: 1/1"
	else: get_node("Item").text = "ITEM: 0/1"

func _on_area_2d_mouse_entered():
	get_node("Desciption").visible = true


func _on_area_2d_mouse_exited():
	get_node("Desciption").visible = false


func _on_area_2d_input_event(viewport, event, shape_idx):
	if player.safe : return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			get_parent().get_node("Board/FloorGrid").select_tile(player.pos)
