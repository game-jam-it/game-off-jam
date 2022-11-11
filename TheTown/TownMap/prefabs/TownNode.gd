class_name TownNode
extends RigidBody2D

signal mouse_entered_node(coords)
signal mouse_exited_node(coords)

const PI2 = PI*2

var type = 0

var size = 48
var radius = 1
var coords = Vector2.ZERO
var location = Vector2.ZERO
var base_color = Color(0.24, 0.24, 0.24)
var hover_color = Color(0.72, 0.72, 0.72)

var mouse_hover = false

func _process(_delta):
	update()

func _draw():
	if !TheTown.draw_debug:
		return

	var offset = Vector2(size, size)
	var bounds = Rect2(global_position - offset, offset * 2.0)
	var render = Rect2($Shape.position - offset, offset * 2.0)

	if bounds.has_point(get_global_mouse_position()):
		draw_rect(render, hover_color, false)
		if !mouse_hover:
			mouse_hover = true
			emit_signal("mouse_entered_node", coords)
	else:
		draw_rect(render, base_color, false)
		if mouse_hover:
			mouse_hover = false
			emit_signal("mouse_exited_node", coords)


func set_coords(value:Vector2):
	var grid = TheTown.get_grid()
	location = grid.get_location(value)
	coords = value
	self.position = location

func set_location(value:Vector2):
	var grid = TheTown.get_grid()
	coords = grid.get_coords(value)
	location = value
	self.position = location

func set_colors(base:Color, hover:Color):
	base_color = base
	hover_color = hover

func set_radius(value:int, scale:float):
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.72
	s.extents = Vector2(scale, scale)
	$Shape.shape = s
	radius = value
	size = scale