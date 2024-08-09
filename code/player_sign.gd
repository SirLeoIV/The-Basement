@tool
extends Sprite2D


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

func update(sanity: int, health: int, max_sanity: int, max_health: int):
	get_node("Sanity").text = "SANITY: " + str(sanity) + "/" + str(max_sanity)
	get_node("Health").text = "HEALTH: " + str(health) + "/" + str(max_health)

func _on_area_2d_mouse_entered():
	get_node("Desciption").visible = true


func _on_area_2d_mouse_exited():
	get_node("Desciption").visible = false
