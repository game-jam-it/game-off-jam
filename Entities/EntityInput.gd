class_name EntityInput
extends Node2D

var entity = null

var _grid: EventGrid = null


func disable():
	pass

func enable(grid):
	_grid = grid

func initialize(ent) -> void:
	entity = ent

func end_turn():
	print("%s missing overwrite of the input.end_turn() method" % name)

func start_turn(grid):
	_grid = grid
	print("%s missing overwrite of the input.start_turn() method" % name)

func choose_action():
	print("%s missing overwrite of the input.choose_action() method" % name)

func choose_target():
	print("%s missing overwrite of the input.choose_target() method" % name)
