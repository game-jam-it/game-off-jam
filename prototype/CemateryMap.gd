extends Node2D

const radius: int = 32

var map = {}
var hexgrid = null

var HexCell = preload("res://TheTown/HexMap/HexCell.gd")
var HexGrid = preload("res://TheTown/HexMap/HexGrid.gd")

var TownHex = preload("res://TheTown/EventMap/prefabs/EventHex.tscn")

func _ready():
	_draw_node(position, 24, 0)


func _draw_node(location: Vector2, size: int, _type: int):
	var length = size * 2
	hexgrid = HexGrid.new(Vector2(radius, radius))
	hexgrid.set_bounds(Vector2(-length, -length), Vector2(length, length))

	# FIXME: This depends on radius 
	# being set to double tile size.
	# print_debug(size / (radius * 0.5))
	var distance = round(abs(size / 2.0) - 0.1) - 1

	var hex = hexgrid.pixel_to_hex(location)
	var coords = hex.get_axial_coords()
	if map.has(coords):
		map[coords].set_color(Color.darkorange)
	else:
		var node = TownHex.instance()
		node.set_color(Color.darkorange)
		node.set_coords(coords)
		map[coords] = node
		self.add_child(node)

	var list = hex.get_all_within(distance)
	for h in list:
		coords = h.get_axial_coords()
		if !map.has(coords):
			hex = HexCell.new(coords)
			location = hexgrid.hex_to_pixel(hex)
			var node = TownHex.instance()
			node.set_color(Color.pink)
			node.set_location(location)
			node.set_coords(coords)
			map[coords] = node
			self.add_child(node)
