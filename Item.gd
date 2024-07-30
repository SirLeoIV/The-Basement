extends Sprite2D

enum types {BOTTLE, GLASS, RECIPE}

var pos = Vector2i(-1, -1)
var retrieved = false
var type = types.BOTTLE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_pos(new_pos: Vector2i):
	set_position(Vector2i(16 + new_pos.x*32, 16 + new_pos.y*32))
	pos = new_pos

func hit(tile: Vector2i):
	return pos.x == tile.x && pos.y == tile.y
