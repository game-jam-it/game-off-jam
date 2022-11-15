class_name TownEvents
extends Node2D

signal event_clear(coords)
signal event_focused(coords)
signal event_selected(coords)

var path = AStar.new()
var road = AStar.new()

var nodes = {}
var events = {}

# var empty_event = {}
# var center_event = {}
# var country_event = {}
# var outskirt_event = {}

var event_coords

var TownNode = preload("res://TheTown/TownMap/prefabs/TownNode.tscn")

func _ready():
	pass


func get_node(coords):
	if nodes.has(coords):
		return nodes[coords]
	return null

func get_event(coords):
	if events.has(coords):
		return events[coords]
	return null


func clear():
	nodes.clear()
	events.clear()
	# empty_event.clear()
	# center_event.clear()
	# country_event.clear()
	# outskirt_event.clear()
	for node in self.get_children():
		node.queue_free()

func create(radius: int, size: float, location: Vector2):
	# Note: Creator expects these to be in position 0.8 seconds after
	# they where created, once passed it wil lock them on to the grid.
	var scale = 5 * size
	
	match radius:
		1: scale =  5 * size
		2: scale =  7 * size
		3: scale =  9 * size
		4: scale = 11 * size

	var node = TownNode.instance()
	node.connect("mouse_entered_node", self, "on_mouse_entered_event")
	node.connect("mouse_exited_node", self, "on_mouse_exited_event")
	node.set_radius(radius, scale)
	node.set_location(location)
	nodes[node.coords] = node
	self.add_child(node)


func handle_input(input):
	if event_coords != null && input.is_action_pressed("mouse_click"):
		emit_signal("event_selected", event_coords)

func on_mouse_exited_event(coords):
	if !self.visible:
		return
	if event_coords == coords:
		event_coords = null
	emit_signal("event_clear", coords)
	# TODO Clear Event Info

func on_mouse_entered_event(coords):
	if self.visible:
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
