extends EntityInput

export(int) var view_perseption = 50

onready var actor_hex = $ActorHex
onready var target_hex = $TargetHex

var _grid: EventGrid
var _target: Entity = null


func clear_target():
	_target = null

func set_target(entity: Entity):
	_target = entity


"""
	EntityInput Override
"""

func end_turn():
	target_hex.visible = false
	actor_hex.visible = false

func start_turn(grid: EventGrid):
	actor_hex.visible = true
	_grid = grid

func choose_action():
	print("%s: choose action" % entity.name)
	var to = _target.get_grid_cell()
	var from = entity.get_grid_cell()
	if from.distance_to(to) == 1:
		return _attack_target(to, from)
	var los = _grid.get_line_of_sight_cover(from, to)
	if los < self.view_perseption:
		return _move_to_target(to, from)
	return _search_for_target()

func choose_target():
	print("%s: choose target" % entity.name)
	yield(get_tree().create_timer(0.2), 'timeout')

	if _target == null:
		return null

	target_hex.global_position = _target.global_position
	target_hex.visible = true
	return _target

"""
	Posible Actions
"""

func _attack_target(to, from):
	print("> %s: Got you, I will chew you up" % entity.name)
	yield(get_tree().create_timer(0.2), 'timeout')
	var act = get_node("%AttackTo")
	act.target = _target
	act.location = _grid.hexgrid.hex_to_pixel(to)
	return act

func _move_to_target(to, from):
	yield(get_tree().create_timer(0.2), 'timeout')
	var path = _grid.hexgrid.find_path(from, to)
	if path.size() < 2: return null

	var hex = path[1]
	var cell = _grid.get_cell_state(hex.get_axial_coords())
	if cell.state == EventGrid.CellState.Entity:
		print("> %s: Out of my way, I want to eat it" % entity.name)
		return null	
	elif cell.state == EventGrid.CellState.Blocker:
		print("> %s: Break this thing, it is in my way" % entity.name)
		return null	
	print("> %s: I'm comming for you, better hide" % entity.name)
	var act = get_node("%MoveTo")
	act.location = _grid.hexgrid.hex_to_pixel(hex)
	return act

func _search_for_target():
	print("> %s: I will find your stinking behind" % entity.name)
	yield(get_tree().create_timer(0.2), 'timeout')
	# TODO Implement
	return null
