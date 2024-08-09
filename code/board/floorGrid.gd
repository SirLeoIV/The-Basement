extends TileMap

var width = 13
var height = 10
var hovered = Vector2i(-1, -1)
var selected = Vector2i(-1, -1)

func _ready():
	#set_cell(0, Vector2i(2,2), 2, Vector2i(0,0), 0)
	pass # Replace with function body.

func _process(delta):
	erase_tile(0)
	erase_tile(1)
	var mouse_pos = (get_global_mouse_position())
	var position_vector = Vector2i(
		mouse_pos.x - get_parent().get_transform().get_origin().x, 
		mouse_pos.y - get_parent().get_transform().get_origin().y) / 2
	var tile_vec = local_to_map(position_vector)
	if tile_vec.x < width && tile_vec.x >= 0 && tile_vec.y < height && tile_vec.y >= 0:
		set_cell(1, local_to_map(position_vector), 0, Vector2i(0,0), 0)
		hovered = Vector2i(tile_vec)
	else:
		hovered = Vector2i(-1, -1)
	if selected.x != -1 && selected.y != -1:
		set_cell(0, selected, 1, Vector2i(0,0), 0)
	
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			var tile_vec = local_to_map(Vector2i(
				event.position.x - get_parent().get_transform().get_origin().x, 
				event.position.y - get_parent().get_transform().get_origin().y) / 2)
			if selected.x == tile_vec.x && selected.y == tile_vec.y:
				deselect_tile()
			elif tile_vec.x < width && tile_vec.x >= 0 && tile_vec.y < height && tile_vec.y >= 0:
				select_tile(tile_vec)
				
func erase_tile(id, layer = -1):
	for i in width:
		for j in height:
			if layer == -1:
				for k in get_layers_count():
					if (get_cell_source_id(k, Vector2i(i,j)) == id):
						erase_cell(k, Vector2i(i,j))
			else:
				if (get_cell_source_id(layer, Vector2i(i,j)) == id):
					erase_cell(layer, Vector2i(i,j))
				

func select_tile(tile: Vector2i):
	selected = tile
	get_parent().select(tile)
	
func deselect_tile():
	selected = Vector2i(-1, -1)
	get_parent().select(selected)
	
