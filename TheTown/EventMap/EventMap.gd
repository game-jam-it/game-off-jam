class_name EventMap
extends Node2D

signal pause_explore_event(coords)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func handle_input(input):
	if input.is_action_pressed("ui_cancel"):
		print_debug("Eventmap -> pause_explore_event")
		emit_signal("pause_explore_event")

func end_mode(_coords):
	# TODO Expand System
	# Rename to mode
	visible = false
	pass

func start_mode(_coords):
	# TODO Expand System
	# Rename to mode
	visible = true
	pass