extends EntityInput

var HexCell = preload("res://TheTown/HexMap/HexCell.gd")

enum Goal {
	None,
	Action,
	Target,
}

signal _action_selected(action)
signal _target_selected(target)

onready var actor_hex = $ActorHex
onready var target_hex = $TargetHex

onready var target_cell = HexCell.new(Vector2(0, 0))

var _goal = Goal.None
var _grid: EventGrid = null

"""
	EntityInput Override
"""

func disable():
	_goal = Goal.None
	emit_signal("_target_selected", null)
	emit_signal("_action_selected", null)

func enable(grid):
	_grid = grid

func end_turn():
	target_hex.visible = false
	actor_hex.visible = false
	_goal = Goal.None

func start_turn():
	target_hex.visible = true
	actor_hex.visible = true
	_goal = Goal.None

func choose_action():
	_enter_action_state()
	return yield(self, "_action_selected")

func choose_target():
	_enter_target_state()
	return yield(self, "_target_selected")


"""
	Handle Player Input
"""

func _process(delta):
	match _goal:
		Goal.Action: _action_process(delta)
		Goal.Target: _target_process(delta)

func _unhandled_input(event):
	if _goal == Goal.Target:
		_target_input(event)

"""
	Handle Action Input
"""

func _action_process(_delta):
	# There is no action input as in all cases only one action can be performed
	var to = _grid.hexgrid.pixel_to_hex(target_hex.position + entity.position)
	var from = entity.get_grid_cell()
	var action = null
	if from.distance_to(to) == 1:
		var cell = _grid.get_cell_state(to.get_axial_coords())
		if cell.state == EventGrid.CellState.Entity:
			action = _handle_entity(to, cell.entity)
		elif cell.state != EventGrid.CellState.Blocker:
			action = self.move_to(to)
		# TODO else target is blocked, break it?
	else:
		action = _try_to_move(to, from)
	_exit_action_state()
	emit_signal("_action_selected", action)

func _exit_action_state():
	_goal = Goal.None
	target_hex.visible = false
	# Note: MVP only has two actions
	# Thus no 'action selection' to hide

func _enter_action_state():
	_goal = Goal.Action
	# Note: MVP only has two actions
	# Thus no 'action selection' to show,
	# _action_process is the same as the bot
	print("%s: choose action" % entity.name)


"""
	Handle Target Input
"""

func _target_input(event):
	if event.is_action_pressed("ui_cancel"):
		if !TheTown.is_paused(): TheTown.pause_game()
		else: TheTown.resume_game()
	if !TheTown.is_paused():
		if event.is_action_pressed("ui_focus_next"):
			_exit_target_state()
			emit_signal("_target_selected", null)
		if event.is_action_pressed("mouse_click"):
			_exit_target_state()
			# Note: this does not reset the target
			var target = _grid.hexgrid.pixel_to_hex(target_hex.position)
			emit_signal("_target_selected", target)

func _target_process(_delta):
	var pos = get_global_mouse_position() - self.global_position
	var hex = _grid.hexgrid.pixel_to_hex(pos)
	if !hex.equals(target_cell):
		target_hex.position = _grid.hexgrid.hex_to_pixel(hex)
		target_cell = hex

func _exit_target_state():
	_goal = Goal.Action

func _enter_target_state():
	_goal = Goal.Target
	#print("%s: choose target" % entity.name)

"""
	Move Actions
"""

func move_to(hex):
	#print("> %s: Not scared, get over here rat" % entity.name)
	var action = get_node("%MoveTo")
	action.location = _grid.hexgrid.hex_to_pixel(hex)
	return action

func _try_to_move(to, from):
	var path = _grid.hexgrid.find_path(from, to)
	if path.size() < 2: 
		return null
	var hex = path[1]
	var cell = _grid.get_cell_state(hex.get_axial_coords())
	if cell.state == EventGrid.CellState.Entity:
		return _handle_entity(hex, cell.entity)
	elif cell.state != EventGrid.CellState.Blocker:
		return self.move_to(hex)

"""
	Entity Actions
"""

func _handle_entity(hex, entity):
	match entity.group:
		EntityObject.Group.Enemy:
			return _attack_target(hex, entity)
		EntityObject.Group.Challenge:
			return _setup_challange(hex, entity)

func _attack_target(hex, target):
	#print("> %s: I will purge you, beat you" % entity.name)
	var act = get_node("%AttackTo")
	act.target = target
	act.location = _grid.hexgrid.hex_to_pixel(hex)
	return act

func _setup_challange(hex, target):
	# TODO Implement chalange action
	if target is Challange:
		print(">>> Check challange: '%s'" % target.name)
		return target.check(self.entity)
	return null
