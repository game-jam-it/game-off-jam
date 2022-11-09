class_name TownEventsNode
extends Node2D

var path = AStar.new()
var road = AStar.new()

var event = {}

var TownNode = preload("res://TheTown/Townmap/prefabs/TownNode.tscn")

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
	node.set_radius(radius, scale)
	node.set_location(location)
	self.add_child(node)
