class_name EntityObject
extends Node2D

enum Group {
	None,
	Enemy,
	Player,
	Lore,
	Pickup,
	Challenge,
}

signal free_entity(entity)

export(Group) var group = Group.None
export(float) var initiative = 1.0

var _grid

var _id: int = 0
var _free: bool = false

func id():
	return _id

func is_free():
	return _free


func _ready():
	# Note: ID means all entities
	# require the same parent node
	self._id = self.get_index()

func set_grid(grid):
	_grid = grid
	_free = false;
	_grid.add_entity(self)
	var list = get_children()
	for node in list:
		if node is GridObject:
			_grid.add_object(node)
	var hex = _grid.hexgrid.pixel_to_hex(position)
	self.position = _grid.hexgrid.hex_to_pixel(hex)

func free_entity():
	_free = true
	self.disable()
	_grid.clear_entity(self)
	# Note: The Queue will free it
	emit_signal("free_entity", self)


func disable():
	pass

func get_grid_cell():
	if _grid == null: return null
	return _grid.hexgrid.pixel_to_hex(position)
