class_name EntityObject
extends Node2D

enum Group {
	None,
	Enemy,
	Player,
}

signal free_entity(entity)

export(Group) var group = Group.None
export(float) var initiative = 1.0

onready var input: EntityInput = $Input
onready var actions: Node2D = $Actions

onready var sense_area = $SenseArea

var _grid
var _free: bool = false


func _ready():
	input.initialize(self)
	for action in actions.get_children():
		action.initialize(self)


func disable():
	sense_area.monitorable = false
	sense_area.monitoring = false
	_grid.clear_entity(self)
	_grid = null

func enable(grid):
	_grid = grid
	_free = false;
	_grid.add_entity(self)
	sense_area.monitoring = true
	sense_area.monitorable = true
	var hex = _grid.hexgrid.pixel_to_hex(position)
	self.position = _grid.hexgrid.hex_to_pixel(hex)


func is_free():
	return _free
	
func free_entity():
	disable()
	_free = true
	# Note: The Queue will free it
	emit_signal("free_entity", self)


func end_turn():
	input.end_turn()

func start_turn():
	input.start_turn(_grid)


func get_grid_cell():
	if _grid == null:
		return
	return _grid.hexgrid.pixel_to_hex(position)