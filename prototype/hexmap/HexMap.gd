extends Node2D

const size: float = 32.0

var HexGrid = preload("./HexGrid.gd")
var NodeScene = preload("res://prototype/hexmap/HexNode.tscn")

var hexgrid = HexGrid.new()

func _ready():
	_create_map()


func _create_map():
	hexgrid = HexGrid.new()
	hexgrid.set_hex_scale(Vector2(size, size))
	for x in range(-12, 12):
		var q = x >> 1
		for y in range(-8-q, 8-q):
			var hex = NodeScene.instance()
			var coords = hexgrid.get_hex_center_for(Vector2(x, y))
			print("%s - %s" % [coords.x, coords.y])
			hex.position = coords
			$Nodes.add_child(hex)

