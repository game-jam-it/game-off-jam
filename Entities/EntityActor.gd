class_name EntityActor
extends EntityObject

onready var input: EntityInput = $Input
onready var actions: Node2D = $Actions

onready var sense_area = $SenseArea

func _ready():
	# Note: ID means all entities
	# require the same parent node
	self._id = self.get_index()
	if input != null:
		input.initialize(self)
	if actions != null:
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
