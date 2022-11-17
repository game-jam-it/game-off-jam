class_name Entity
extends Node2D

export var initiative: float = 1.0

onready var input: EntityInput = $Input
onready var actions: Node2D = $Actions

func _ready():
	input.initialize(self)
	for action in actions.get_children():
		action.initialize(self)

func end_turn():
	input.end_turn()

func start_turn(grid):
	input.start_turn(grid)
