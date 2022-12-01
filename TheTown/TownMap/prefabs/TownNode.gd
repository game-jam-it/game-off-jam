class_name TownNode
extends RigidBody2D

enum Type {
	None,
	Center,
	Country,
	Outskirt,
}

signal mouse_exited_node(coords)
signal mouse_entered_node(coords)

const PI2 = PI*2

var type = 0
var info = null

var size = 0
var radius = 1
var coords = Vector2.ZERO
var location = Vector2.ZERO
var base_color = Color(0.24, 0.24, 0.24)
var hover_color = Color(0.72, 0.72, 0.72)

var mouse_hover = false

# func _ready():
# 	self.connect("input_event", self, "on_input_event")

func _process(_delta):
	if TheTown.is_paused() || !TheTown.is_ready():
		return
	var offset = Vector2(size, size)
	var bounds = Rect2(global_position - offset, offset * 2.0)
	if bounds.has_point(get_global_mouse_position()):
		if !mouse_hover:
			mouse_hover = true
			emit_signal("mouse_entered_node", coords)
	else:
		if mouse_hover:
			mouse_hover = false
			emit_signal("mouse_exited_node", coords)
	update()

func _unhandled_input(event):
	if TheTown.get_state() != TheTown.State.PrepMode:
		return
	if event is InputEventMouseButton and event.doubleclick:
		if mouse_hover: 
			print("Mouse Double Clicked on %s" % name)
			# TheTown -> Overlay -> TownHud -> on ...
			Overlay.town_hud.on_start_expedition(coords)

func _draw():
	# FixMe: Untill we have an other indicator
	# the debug box is the only way to show hovers
	# if !TheTown.draw_debug:
	# 	return
	var scn = TheTown.get_events().get_scene(coords)
	if scn == null || scn.is_locked() || scn.is_complete():
		return

	var offset = $Shape.shape.extents
	var render = Rect2($Shape.position - offset, offset * 2.0)
	if TheTown.is_paused():
		draw_rect(render, base_color, false)
		return
	if TheTown.get_state() != TheTown.State.PrepMode:
		draw_rect(render, base_color, false)
		return
	# This is a mess but we need the updated locked value
	var scene = TheTown.get_events().get_scene(coords)
	if scene == null || scene.is_locked():
		draw_rect(render, base_color, false)
		return
	# TODO Next: This should not just hover, it needs to be the coords
	# var bounds = Rect2(global_position - offset, offset * 2.0)
	# if !bounds.has_point(get_global_mouse_position()):
	if TheTown.event_coords() != coords:
		draw_rect(render, base_color, false)
		return
	draw_rect(render, hover_color, false)


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
	s.extents = Vector2(scale+1, scale+1)
	$Shape.shape = s
	radius = value
	size = scale
