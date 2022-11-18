extends EntityInput

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
	if _grid.get_line_of_sight_cover(from, to) == 0:
		print("> %s: Found you, I will chew you up." % entity.name)
		# TODO If distance 
		# == 1 -> Attack
		# > 1 -> MoveTo
	else:
		print("> %s: I will find your smelly ass" % entity.name)
		# TODO: Search pattern

	yield(get_tree().create_timer(0.4), 'timeout')
	return null

func choose_target():
	print("%s: choose target" % entity.name)

	if _target == null:
		yield(get_tree().create_timer(0.4), 'timeout')
		return null

	target_hex.position = _target.position
	target_hex.visible = true

	yield(get_tree().create_timer(0.4), 'timeout')
	return _target
