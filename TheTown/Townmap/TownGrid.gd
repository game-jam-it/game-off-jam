class_name TownGridNode
extends Node2D

const radius: int = 128

var map = {}
var path = {}
var road = {}

var width = 0
var height = 0
var hexgrid = null

var HexCell = preload("res://TheTown/Hexmap/HexCell.gd")
var HexGrid = preload("res://TheTown/Hexmap/HexGrid.gd")

var TownHex = preload("res://TheTown/Townmap/prefabs/TownHex.tscn")

func _ready():
	_init_grid()

func _init_grid():
	# TODO: Make size independed of the window
	width = round(OS.window_size.x / radius) * 4
	height = round(OS.window_size.y / radius) * 4
	hexgrid = HexGrid.new(Vector2(radius, radius))
	hexgrid.set_bounds(Vector2(-width, -height-width), Vector2(width, height+width))

func clear():
	map.clear()
	path.clear()
	road.clear()
	_init_grid()
	for node in self.get_children():
		node.queue_free()

func get_coords(location: Vector2):
	var hex = hexgrid.pixel_to_hex(location)
	return hex.get_axial_coords()

func get_location(coords: Vector2):
	var hex = HexCell.new(coords)
	return hexgrid.hex_to_pixel(hex)


"""
	Renders the town layout to the grid
"""

func draw_road(from: Vector3, to: Vector3):
	var draw = false;
	for hex in _get_road(from, to):
		var coords = hex.get_axial_coords()
		if !map.has(coords):
			var node = TownHex.instance()
			node.set_color(Color.blue)
			node.set_coords(coords)
			map[coords] = node
			self.add_child(node)
			# TODO: Expand with art
			draw = true
	return draw

func draw_path(from: Vector3, to: Vector3):
	var draw = false;
	for hex in _get_path(from, to):
		var coords = hex.get_axial_coords()
		if !map.has(coords):
			var node = TownHex.instance()
			node.set_color(Color.green)
			node.set_coords(coords)
			map[coords] = node
			self.add_child(node)
			# TODO: Expand with art
			draw = true
	return draw

func draw_node(location: Vector2, size: int, _type: int):
	# FIXME: This depends on radius 
	# being set to double tile size.
	# print_debug(size / (radius * 0.5))
	var distance = round(abs((size / (radius * 0.5)) / 2.0) - 0.1) - 1

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
			var node = TownHex.instance()
			node.set_color(Color.dimgray)
			node.set_coords(coords)
			map[coords] = node
			self.add_child(node)

func _get_road(from: Vector3, to: Vector3):
	var origin = hexgrid.pixel_to_hex(Vector2(from.x, from.y))
	var target = hexgrid.pixel_to_hex(Vector2(to.x, to.y))
	road[origin.get_axial_coords()] = true
	if road.has(target.get_axial_coords()): return []
	return hexgrid.find_path(origin, target)

func _get_path(from: Vector3, to: Vector3):
	var origin = hexgrid.pixel_to_hex(Vector2(from.x, from.y))
	var target = hexgrid.pixel_to_hex(Vector2(to.x, to.y))
	var oc = origin.get_axial_coords()
	var tc = target.get_axial_coords()
	path[oc] = true
	# Skip return path and roads
	if path.has(tc): return []
	if road.has(tc) && road.has(oc): return []
	return hexgrid.find_path(origin, target)
