class_name TownEvents
extends Node2D

signal pause_explore_event(coords)

var scenes = {}
var active = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func clear():
	scenes.clear()
	for node in self.get_children():
		node.queue_free()

func handle_input(input):
	if active != null:
		return

	if input.is_action_pressed("ui_cancel"):
		print_debug("Eventmap -> pause_explore_event")
		emit_signal("pause_explore_event")

func end_event(coords):
	if active != null:
		active.end_event()
		active = null

func start_event(coords):
	if active != null:
		active.end_event()
		active = null
	if scenes.has(coords):
		active = scenes[coords]
		active.start_event()
