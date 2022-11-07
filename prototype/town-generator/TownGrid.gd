class_name TownGrid
extends Node2D

const radius: int = 128

var map = {}
var side = {}
var mains = {}

var width = 0
var height = 0
var hexgrid = null

var HexCell = preload("../hexmap/HexCell.gd")
var HexGrid = preload("../hexmap/HexGrid.gd")

var GridNode = preload("res://prototype/town-generator/GridNode.tscn")

func _ready():
	_init_grid()
	print_debug("Town grid done")

func _init_grid():
	# TODO: Make size independed of the window
	width = round(OS.window_size.x / radius) * 4
	height = round(OS.window_size.y / radius) * 4
	print_debug("Size: %s. %s" % [width, height])

func clear_grid():
	map.clear()
	side.clear()
	mains.clear()
	hexgrid = HexGrid.new(Vector2(radius, radius))
	hexgrid.set_bounds(Vector2(-width, -height-width), Vector2(width, height+width))
	for n in $Nodes.get_children():
		n.queue_free()

func draw_main_road(from: Vector3, to: Vector3):
	var draw = false;
	for hex in get_main_path(from, to):
		var coords = hex.get_axial_coords()
		if !map.has(coords):
			var node = GridNode.instance()
			node.set_color(Color.blue)
			node.set_coords(hexgrid.hex_to_pixel(hex))
			map[hex.get_axial_coords()] = node
			$Nodes.add_child(node)
			# TODO: Expand with art
			draw = true
	return draw

func get_main_path(from: Vector3, to: Vector3):
	var origin = hexgrid.pixel_to_hex(Vector2(from.x, from.y))
	var target = hexgrid.pixel_to_hex(Vector2(to.x, to.y))
	# Skip return path
	#side[origin.get_axial_coords()] = true
	mains[origin.get_axial_coords()] = true
	if mains.has(target.get_axial_coords()): return []
	return hexgrid.find_path(origin, target)

func draw_side_road(from: Vector3, to: Vector3):
	var draw = false;
	for hex in get_side_path(from, to):
		var coords = hex.get_axial_coords()
		if !map.has(coords):
			var node = GridNode.instance()
			node.set_color(Color.green)
			node.set_coords(hexgrid.hex_to_pixel(hex))
			map[hex.get_axial_coords()] = node
			$Nodes.add_child(node)
			# TODO: Expand with art
			draw = true
	return draw

func get_side_path(from: Vector3, to: Vector3):
	var origin = hexgrid.pixel_to_hex(Vector2(from.x, from.y))
	var target = hexgrid.pixel_to_hex(Vector2(to.x, to.y))
	# Skip return path
	var oc = origin.get_axial_coords()
	var tc = target.get_axial_coords()
	side[oc] = true
	if side.has(tc): return []
	if mains.has(tc) && mains.has(oc): return []
	return hexgrid.find_path(origin, target)

func draw_town_node(position: Vector2, size: Vector2, _type: int):
	# Note: This depends on radius 
	# being set to double tile size.
	print_debug(size.x / (radius * 0.5))
	var distance = round(abs((size.x / (radius * 0.5)) / 2.0) - 0.1) - 1

	var hex = hexgrid.pixel_to_hex(position)
	var coords = hex.get_axial_coords()
	if map.has(coords):
		map[coords].set_color(Color.darkorange)
	else:
		var node = GridNode.instance()
		node.set_color(Color.darkorange)
		node.set_coords(hexgrid.hex_to_pixel(hex))
		map[coords] = node
		$Nodes.add_child(node)

	var list = hex.get_all_within(distance)
	for h in list:
		var c = h.get_axial_coords()
		if !map.has(c):
			var node = GridNode.instance()
			node.set_color(Color.dimgray)
			node.set_coords(hexgrid.hex_to_pixel(h))
			map[c] = node
			$Nodes.add_child(node)
