class_name TownEvents
extends Node2D

signal event_clear(coords)
signal event_focused(coords)
signal event_selected(coords)

var path = AStar.new()
var road = AStar.new()

var event = {}
var event_coords

var TownNode = preload("res://TheTown/TownMap/prefabs/TownNode.tscn")

func _ready():
	pass

func clear():
	for node in self.get_children():
		node.queue_free()

func create(radius: int, size: float, location: Vector2):
	# Note: Creator expects these to be in position 0.8 seconds after
	# they where created, once passed it wil lock them on to the grid.
	var scale = 5 * size
	match radius:
		1: scale =  7 * size
		2: scale =  9 * size
		3: scale = 11 * size

	var node = TownNode.instance()
	node.connect("mouse_entered_node", self, "on_mouse_entered_event")
	node.connect("mouse_exited_node", self, "on_mouse_exited_event")
	node.set_radius(radius, scale)
	node.set_location(location)
	self.add_child(node)


func handle_input(input):
	if event_coords != null && input.is_action_pressed("mouse_click"):
		emit_signal("event_selected", event_coords)

func on_mouse_exited_event(coords):
	if event_coords == coords:
		event_coords = null
	emit_signal("event_clear", coords)
	# TODO Clear Event Info

func on_mouse_entered_event(coords):
		event_coords = coords
		emit_signal("event_focused", coords)

func show_mode(_coords):
	# TODO Expand System
	# Set grid as child
	# Rename to mode
	visible = true

func hide_mode(_coords):
	# TODO Expand System
	# Set grid as child
	# Rename to mode
	visible = false