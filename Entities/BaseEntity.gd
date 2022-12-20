class_name BaseEntity
extends Node2D

enum Group {
	None,
	Dare,
	Lore,
	Item,
	Enemy,
	Player,
}

signal free_entity(entity)
signal unhide_entity(entity)

export(Group) var group = Group.None
export(bool) var snap = true
export(bool) var hidden = false

var _grid: Object = null

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
	if self.snap:
		var hex = _grid.hexgrid.pixel_to_hex(position)
		self.position = _grid.hexgrid.hex_to_pixel(hex)
	if not self.hidden:
		_grid.add_entity(self)
		var list = get_children()
		for node in list:
			if node is GridObject:
				_grid.add_object(node)

func free_entity():
	_free = true
	self.disable()
	var list = get_children()
	for node in list:
		if node is GridObject:
			_grid.clear_object(node)
	_grid.clear_entity(self)
	# Note: The Queue will free it
	emit_signal("free_entity", self)

func unhide_entity():
	if not hidden:
		return
	hidden = false
	_grid.add_entity(self)
	var list = get_children()
	for node in list:
		if node is GridObject:
			_grid.add_object(node)
	emit_signal("unhide_entity", self)

func disable():
	pass

func get_grid_cell():
	if _grid == null: return null
	return _grid.hexgrid.pixel_to_hex(position)
