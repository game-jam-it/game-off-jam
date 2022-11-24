extends Camera2D

const BASE_X = 1280.0
const BASE_Y = 720.0

var panning = false

var zoom_in = Vector2(0.75, 0.75)
var focus_on = Vector2(7.5, 7.5)
var zoom_out = Vector2(15.0, 15.0)

var zoom_last =Vector2(15.0, 15.0)

export var init_zoom = Vector2(20.0, 20.0)
export var init_offset = Vector2(0.0, 256.0)

onready var viewport_ratio = Vector2.ONE
onready var viewport_offset = get_viewport().size * 0.5
onready var viewport_transform = get_viewport_transform()

func _ready():
	get_viewport().connect("size_changed", self, "_on_size_changed")
	viewport_ratio = Vector2(BASE_X, BASE_Y) / get_viewport().size
	zoom_init()
	
func _input(event):
	if event.is_action_pressed("mouse_pan"):
		panning = true
	elif event.is_action_released("mouse_pan"):
		panning = false
	if panning == true && event is InputEventMouseMotion:
		offset -= event.relative * zoom

func zoom_init():
	zoom = self.init_zoom
	zoom_last = self.init_zoom
	offset = self.init_offset + (get_viewport().size * 0.5)
	viewport_offset = get_viewport().size * 0.5
	viewport_transform = get_viewport_transform()

func zoom_reset():
	zoom = self.zoom_out
	zoom_last = self.zoom_out
	offset = get_viewport().size * 0.5
	viewport_offset = get_viewport().size * 0.5
	viewport_transform = get_viewport_transform()

func _on_size_changed():
	zoom = zoom_last
	offset = get_viewport().size * 0.5
	viewport_ratio = Vector2(BASE_X, BASE_Y) / get_viewport().size
	viewport_offset = get_viewport().size * 0.5
	viewport_transform = get_viewport_transform()

func set_zoom_to(location:Vector2):
	zoom = self.zoom_in
	zoom_last = self.zoom_in
	var target = viewport_transform * location
	offset = viewport_offset - (viewport_offset - target) * (15 * viewport_ratio)

func set_focus_to(location:Vector2):
	zoom = self.focus_on
	zoom_last = self.focus_on
	var target = viewport_transform * location
	offset = viewport_offset - (viewport_offset - target) * (15 * viewport_ratio)
