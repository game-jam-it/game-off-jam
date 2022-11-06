extends Node2D

const radius: float = 32.0

var HexCell = preload("./HexCell.gd")
var HexGrid = preload("./HexGrid.gd")
var NodeScene = preload("res://prototype/hexmap/HexNode.tscn")

var active = null
var hexgrid = HexGrid.new(Vector2(radius, radius))

func _ready():
	_create_map()
	_create_nodes()

func _process(_delta):
	var target = get_global_mouse_position()
	var hex = hexgrid.pixel_to_hex(target)
	active.set_position(hexgrid.hex_to_pixel(hex))

func _input(event):
	if event.is_action_pressed("mouse_left"):
		var target = get_global_mouse_position()
		var hex = hexgrid.pixel_to_hex(target)
		print("Hex(%s, %s)" % [hex.q, hex.r])

func _create_map():
	hexgrid = HexGrid.new(Vector2(radius, radius))
	for q in range(-16, 16):
		var offset = q >> 1
		for r in range(-12-offset, 12-offset):
			var hex = HexCell.new(Vector2(q, r))
			var node = NodeScene.instance()
			node.set_position(hexgrid.hex_to_pixel(hex))
			$Nodes.add_child(node)

func _create_nodes():
	active = NodeScene.instance()
	active.size = 16
	active.color = Color(0.48, 0.28, 0.48)
	var hex = HexCell.new(Vector2(0, 0))
	active.set_position(hexgrid.hex_to_pixel(hex))
	add_child(active)
	hex = hexgrid.pixel_to_hex(active.position)
	active = NodeScene.instance()
	active.size = 8
	active.color = Color(0.48, 0.28, 0.28)
	active.set_position(hexgrid.hex_to_pixel(hex))
	add_child(active)

	# Obsicals, obstruct all directions
	for q in range(0, 1):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.1, 0.1)
		hex = HexCell.new(Vector2(q+3, -4))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_obstacles(coord, 0)
		node.set_position(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)
	for r in range(0, 2):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.1, 0.1)
		hex = HexCell.new(Vector2(4, -r-3))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_obstacles(coord, 0)
		node.set_position(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)

	# Obsicals, can be dificult terrain
	for q in range(0, 1):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.1, 0.48)
		hex = HexCell.new(Vector2(q-3, -1))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_obstacles(coord, 0.5)
		node.set_position(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)
	for r in range(0, 2):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.1, 0.48)
		hex = HexCell.new(Vector2(-4, r))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_obstacles(coord, 0.5)
		node.set_position(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)

	# Barriers, have directional dificuly info
	for r in range(0, 3):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.48, 0.1)
		hex = HexCell.new(Vector2(5, r))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_barriers(coord, [
			HexGrid.Direction_N,
			HexGrid.Direction_S,
			HexGrid.Direction_NE,
			HexGrid.Direction_SE
		], 0)
		node.set_position(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)
	for r in range(0, 3):
		var node = NodeScene.instance()
		node.size = 16
		node.color = Color(0.48, 0.48, 0.08)
		hex = HexCell.new(Vector2(-5, -r+7))
		var coord = hex.get_axial_coords()
		hexgrid.add_path_barriers(coord, [
			HexGrid.Direction_N,
			HexGrid.Direction_S,
			HexGrid.Direction_NE,
			HexGrid.Direction_SE
		], 0)
		node.set_position(hexgrid.hex_to_pixel(hex))
		$Barriers.add_child(node)
