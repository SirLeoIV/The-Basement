extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Desciption").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_mouse_entered():
	get_node("Desciption").visible = true


func _on_area_2d_mouse_exited():
	get_node("Desciption").visible = false
