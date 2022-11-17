extends EntityInput

onready var actor_hex = $ActorHex
onready var target_hex = $TargetHex

var _grid: EventGrid

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
	yield(get_tree().create_timer(0.4), 'timeout')
	print("%s choose action" % entity.name)
	yield(get_tree(), "idle_frame")
	return null

func choose_target():
	yield(get_tree().create_timer(0.4), 'timeout')
	print("%s choose target" % entity.name)
	yield(get_tree(), "idle_frame")
	target_hex.visible = true
	return null
