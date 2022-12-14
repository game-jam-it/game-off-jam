extends EntityInput

export(int) var view_perseption = 50

onready var actor_hex = $ActorHex
onready var target_hex = $TargetHex

var _target: BaseEntity = null
var _trigger: BaseEntity = null


func clear_target():
	_target = null


func set_target(entity: BaseEntity):
	_target = entity

func set_trigger(entity: BaseEntity):
	if _trigger != null: _trigger.disconnect("free_entity", self, "_on_free_trigger")
	entity.connect("free_entity", self, "_on_free_trigger")
	_trigger = entity

func _on_free_trigger(entity):
	entity.disconnect("free_entity", self, "_on_free_trigger")
	_trigger = null

"""
	EntityInput Override
"""

func end_turn():
	actor_hex.visible = false
	# target_hex.visible = false

func start_turn(grid):
	_grid = grid
	actor_hex.visible = true
	# target_hex.visible = true

func choose_action():
	if _target != null:
		return self._check_target()
	elif _trigger != null:
		return self._check_trigger()
	yield(get_tree(), "idle_frame")
	return null	

func choose_target():
	#print("%s: choose target" % entity.name)
	#yield(get_tree().create_timer(0.2), 'timeout')
	if _target == null:
		yield(get_tree(), "idle_frame")
		return _trigger

	# target_hex.global_position = _target.global_position
	# target_hex.visible = true
	yield(get_tree(), "idle_frame")
	return _target

func _check_target():
	var to = _target.get_grid_cell()
	var from = entity.get_grid_cell()
	if from.distance_to(to) == 1:
		return _attack_target(to, from)
	var los = _grid.get_line_of_sight_cover(from, to)
	if los < self.view_perseption:
		return _move_to_target(to, from)
	return _search_for_target()

func _check_trigger():
	var to = _trigger.get_grid_cell()
	var from = entity.get_grid_cell()
	return _move_to_target(to, from)

"""
	Posible Actions
"""

func _attack_target(to, _from):
	#print("> %s: Got you, I will chew you up" % entity.name)
	#yield(get_tree().create_timer(0.2), 'timeout')
	var act = get_node("%AttackTo")
	act.target = _target
	act.location = _grid.hexgrid.hex_to_pixel(to)
	yield(get_tree(), "idle_frame")
	return act

func _move_to_target(to, from):
	#yield(get_tree().create_timer(0.2), 'timeout')
	var path = _grid.hexgrid.find_path(from, to)
	if path.size() < 2: return null
	var hex = path[1]
	var cell = _grid.get_cell_state(hex.get_axial_coords())
	if cell.state == EventGrid.CellState.Entity:
		#print("> %s: Out of my way, I want to eat it" % entity.name)
		yield(get_tree(), "idle_frame")
		return null	
	elif cell.state == EventGrid.CellState.Blocker:
		#print("> %s: Break this thing, it is in my way" % entity.name)
		yield(get_tree(), "idle_frame")
		return null	
	target_hex.visible = false
	#print("> %s: I'm comming for you, better hide" % entity.name)
	var act = get_node("%MoveTo")
	act.location = _grid.hexgrid.hex_to_pixel(hex)
	yield(get_tree(), "idle_frame")
	return act

func _search_for_target():
	#print("> %s: I will find your stinking behind" % entity.name)
	#yield(get_tree().create_timer(0.2), 'timeout')
	yield(get_tree(), "idle_frame")
	# TODO Implement
	return null
