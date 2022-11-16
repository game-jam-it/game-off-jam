class_name Entity
extends Node2D

export var initiative: float = 1.0

onready var input = $Input
onready var actions = $Actions

func _ready():
	input.initialize(self)
	for action in actions.get_children():
		action.initialize(self)

