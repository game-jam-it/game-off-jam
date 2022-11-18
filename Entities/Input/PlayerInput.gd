extends EntityInput

var HexCell = preload("res://TheTown/HexMap/HexCell.gd")

enum Goal {
	None,
	Action,
	Target,
	Idling,
}

signal _action_selected(action)
signal _target_selected(target)

onready var actor_hex = $ActorHex
onready var target_hex = $TargetHex

onready var target_cell = HexCell.new(Vector2(0, 0))

var _goal = Goal.None
var _grid: EventGrid

"""
	EntityInput Override
"""

func end_turn():
	target_hex.visible = false
	actor_hex.visible = false
	_goal = Goal.None

func start_turn(grid: EventGrid):
	target_hex.visible = true
	actor_hex.visible = true
	_goal = Goal.Idling
	_grid = grid

func choose_action():
	_enter_action_state()
	return yield(self, "_action_selected")

func choose_target():
	_enter_target_state()
	return yield(self, "_target_selected")


"""
	Handle Player Input
"""

func _input(event):
	match _goal:
		Goal.Action: _action_input(event)
		Goal.Target: _target_input(event)
		Goal.Idling: _idling_input(event)

func _process(delta):
	match _goal:
		Goal.Action: _action_process(delta)
		Goal.Target: _target_process(delta)
		Goal.Idling: _idling_process(delta)


"""
	Handle Action Input
"""

func _action_input(event):
	if event.is_action_pressed("ui_cancel"):
		_exit_action_state()
		emit_signal("_action_selected", null)

func _action_process(_delta):
	pass

func _exit_action_state():
	_goal = Goal.None
	# Note: MVP only has two actions
	# Thus no 'action selection' to hide

func _enter_action_state():
	_goal = Goal.Action
	# Note: MVP only has two actions
	# Thus no 'action selection' to show
	# TODO If no enemy on target -> move to
	# else show available attacks
	print("%s: choose action" % entity.name)


"""
	Handle Target Input
"""

func _target_input(event):
	if event.is_action_pressed("ui_cancel"):
		_exit_target_state()
		emit_signal("_target_selected", null)
	if event.is_action_pressed("mouse_click"):
		_exit_target_state()
		# Note: this does not reset the target
		emit_signal("_target_selected", target_cell)

func _target_process(_delta):
	var pos = get_global_mouse_position() - self.global_position
	var hex = _grid.hexgrid.pixel_to_hex(pos)
	if !hex.equals(target_cell):
		target_hex.position = _grid.hexgrid.hex_to_pixel(hex)
		target_cell = hex
	pass

func _exit_target_state():
	_goal = Goal.Action

func _enter_target_state():
	_goal = Goal.Target
	print("%s: choose target" % entity.name)


"""
	Handle Idle Input
"""
	
func _idling_input(_event):
	pass

func _idling_process(_delta):
	pass
