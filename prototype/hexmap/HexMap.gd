extends Node2D

const radius: float = 32.0

var HexCell = preload("./HexCell.gd")
var HexGrid = preload("./HexGrid.gd")
var NodeScene = preload("res://prototype/hexmap/HexNode.tscn")

var active = null
var hover = null

var path = null
var target = null
var origin = null

var hexgrid = HexGrid.new(Vector2(radius, radius))

func _ready():
	hexgrid = HexGrid.new(Vector2(radius, radius))
	hexgrid.set_bounds(Vector2(-18, -12-18), Vector2(18, 12+18))
	_create_nodes()
	_create_map()

func _process(_delta):
	var pos = get_global_mouse_position()
	var hex = hexgrid.pixel_to_hex(pos)
	if !hex.equals(target):
		print_debug("Update target: %s, %s" % [hex.q, hex.r])
		var coords = hexgrid.hex_to_pixel(hex)
		hover.set_coords(coords)
		target = hex
		set_path()

func _input(event):
	if event.is_action_pressed("mouse_left"):
		var pos = get_global_mouse_position()
		var hex = hexgrid.pixel_to_hex(pos)
		if !hex.equals(origin):
			print("Set origin to: %s, %s" % [hex.q, hex.r])
			var coords = hexgrid.hex_to_pixel(hex)
			active.set_coords(coords)
			origin = hex
			path = []

func set_path():
	if origin.equals(target): path = []
	else: path = hexgrid.find_path(origin, target)
	print("Set path length: %s" % path.size())
	for node in $Path.get_children():
		node.queue_free()
	for hex in path:
		var node = NodeScene.instance()
		node.size = 4
		node.color = Color(0.24, 0.64, 0.24)
		node.set_coords(hexgrid.hex_to_pixel(hex))
		$Path.add_child(node)

func _create_map():
	for q in range(-16, 16):
		var offset = q >> 1
		for r in range(-12-offset, 12-offset):
			var hex = HexCell.new(Vector2(q, r))
			var node = NodeScene.instance()
			node.set_coords(hexgrid.hex_to_pixel(hex))
			$Nodes.add_child(node)

func _create_nodes():
	active = NodeScene.instance()
	active.size = 16
	active.color = Color(0.48, 0.28, 0.48)
	origin = HexCell.new(Vector2(0, 0))
	active.set_coords(hexgrid.hex_to_pixel(origin))
	add_child(active)
	var hex = hexgrid.pixel_to_hex(active.position)
	hover = NodeScene.instance()
	hover.size = 8
	hover.color = Color(0.48, 0.28, 0.28)
	hover.set_coords(hexgrid.hex_to_pixel(hex))
	add_child(hover)

	# Obsicals, obstruct all directions
	for q in range(0, 1):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.1, 0.1)
		hex = HexCell.new(Vector2(q+3, -4))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_obstacles(coord, 0)
		node.set_coords(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)
	for r in range(0, 2):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.1, 0.1)
		hex = HexCell.new(Vector2(4, -r-3))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_obstacles(coord, 0)
		node.set_coords(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)

	# Obsicals, can be dificult terrain
	for q in range(0, 1):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.1, 0.48)
		hex = HexCell.new(Vector2(q-3, -1))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_obstacles(coord, 2)
		node.set_coords(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)
	for r in range(0, 2):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.1, 0.48)
		hex = HexCell.new(Vector2(-4, r))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_obstacles(coord, 2)
		node.set_coords(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)

	# Barriers, have directional dificuly info
	for r in range(0, 4):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.48, 0.1)
		hex = HexCell.new(Vector2(5, r-2))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_barriers(coord, [
			HexGrid.Direction_N,
			HexGrid.Direction_S,
			HexGrid.Direction_NE,
			HexGrid.Direction_SE
		], 2)
		node.set_coords(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)
	for r in range(0, 4):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.48, 0.08)
		hex = HexCell.new(Vector2(-5, -r+6))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_barriers(coord, [
			HexGrid.Direction_N,
			HexGrid.Direction_S,
			HexGrid.Direction_NE,
			HexGrid.Direction_SE
		], 2)
		node.set_coords(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)
