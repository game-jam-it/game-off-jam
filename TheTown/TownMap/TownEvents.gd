class_name TownEvents
extends Node2D

var path = AStar.new()
var road = AStar.new()

var event = {}

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
	node.connect("mouse_entered_node", TheTown, "on_mouse_entered_event")
	node.connect("mouse_exited_node", TheTown, "on_mouse_entered_event")
	node.set_radius(radius, scale)
	node.set_location(location)
	self.add_child(node)
