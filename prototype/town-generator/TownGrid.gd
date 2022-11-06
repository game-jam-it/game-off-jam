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
	width = round(OS.window_size.x / radius) * 4
	height = round(OS.window_size.y / radius) * 4
	print_debug("Size: %s. %s" % [width, height])

func setup_grid():
	map.clear()
	side.clear()
	mains.clear()
	hexgrid = HexGrid.new(Vector2(radius, radius))
	hexgrid.set_bounds(Vector2(-width, -height-width), Vector2(width, height+width))
	for n in $Nodes.get_children():
		n.queue_free()
	for q in range(-width, width):
		var offset = q >> 1
		for r in range(-height-offset, height-offset):
			var hex = HexCell.new(Vector2(q, r))
			var node = GridNode.instance()
			map[hex.get_axial_coords()] = node
			node.set_coords(hexgrid.hex_to_pixel(hex))
			$Nodes.add_child(node)

func draw_main_road(from: Vector3, to: Vector3):
	for hex in get_main_path(from, to):
		var coords = hex.get_axial_coords()
		if map.has(coords):
			var node = map[coords]
			node.set_color(Color.blue)
			# TODO: Expand with art

func get_main_path(from: Vector3, to: Vector3):
	var origin = hexgrid.pixel_to_hex(Vector2(from.x, from.y))
	var target = hexgrid.pixel_to_hex(Vector2(to.x, to.y))
	# Skip return path
	side[origin.get_axial_coords()] = true
	mains[origin.get_axial_coords()] = true
	if mains.has(target.get_axial_coords()): return []
	return hexgrid.find_path(origin, target)

func draw_side_road(from: Vector3, to: Vector3):
	for hex in get_side_path(from, to):
		var coords = hex.get_axial_coords()
		if !mains.has(coords) && map.has(coords):
			var node = map[coords]
			node.set_color(Color.green)
			# TODO: Expand with art

func get_side_path(from: Vector3, to: Vector3):
	var origin = hexgrid.pixel_to_hex(Vector2(from.x, from.y))
	var target = hexgrid.pixel_to_hex(Vector2(to.x, to.y))
	# Skip return path
	side[origin.get_axial_coords()] = true
	if side.has(target.get_axial_coords()): return []
	return hexgrid.find_path(origin, target)

func draw_town_node(position: Vector2, size: Vector2, type: int):
	pass
