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
	active.position = hexgrid.hex_to_pixel(hex)

func _input(event):
	if event.is_action_pressed("click"):
			var target = get_global_mouse_position()
			print_debug(target)

func _create_map():
	hexgrid = HexGrid.new(Vector2(radius, radius))
	for q in range(-12, 12):
		var offset = q >> 1
		for r in range(-8-offset, 8-offset):
			var hex = HexCell.new(q, r)
			var node = NodeScene.instance()
			node.position = hexgrid.hex_to_pixel(hex)
			$Nodes.add_child(node)

func _create_nodes():
	active = NodeScene.instance()
	active.size = 16
	active.color = Color(0.48, 0.28, 0.48)
	var hex = HexCell.new(0, 0)
	active.position = hexgrid.hex_to_pixel(hex)
	add_child(active)
	hex = hexgrid.pixel_to_hex(active.position)
	active = NodeScene.instance()
	active.size = 8
	active.color = Color(0.48, 0.28, 0.28)
	active.position = hexgrid.hex_to_pixel(hex)
	add_child(active)
