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

onready var input: EntityInput = $Input
onready var actions: Node2D = $Actions

onready var sense_area = $SenseArea

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
	input.initialize(self)
	for action in actions.get_children():
		action.initialize(self)


func disable():
	sense_area.monitorable = false
	sense_area.monitoring = false
	input.disable()

func enable():
	sense_area.monitoring = true
	sense_area.monitorable = true
	input.enable(_grid)


func initialize(grid):
	_grid = grid
	_free = false;
	_grid.add_entity(self)
	var hex = _grid.hexgrid.pixel_to_hex(position)
	self.position = _grid.hexgrid.hex_to_pixel(hex)
	
func free_entity():
	_free = true
	self.disable()
	_grid.clear_entity(self)
	# Note: The Queue will free it
	emit_signal("free_entity", self)


func end_turn():
	input.end_turn()

func start_turn():
	input.start_turn()

func choose_target():
	return input.choose_target()

func choose_action():
	return input.choose_action()

func get_grid_cell():
	if _grid == null: return null
	return _grid.hexgrid.pixel_to_hex(position)
