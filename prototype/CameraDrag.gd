extends Camera2D

var panning = false

var zoom_in = Vector2(0.5, 0.5)
var focus_on = Vector2(7.5, 7.5)
var zoom_out = Vector2(15.0, 15.0)

onready var viewport_offset = get_viewport().size * 0.5
onready var viewport_transform = get_viewport_transform()

func _ready():
	zoom_reset()
	
func _input(event):
	if event.is_action_pressed("mouse_pan"):
		panning = true
	elif event.is_action_released("mouse_pan"):
		panning = false
	if panning == true && event is InputEventMouseMotion:
		offset -= event.relative * zoom

func zoom_reset():
	zoom = self.zoom_out
	offset = get_viewport().size * 0.5
	viewport_offset = get_viewport().size * 0.5
	viewport_transform = get_viewport_transform()

func set_zoom_to(location:Vector2):
	zoom = self.zoom_in
	var target = viewport_transform * location
	offset = viewport_offset - (viewport_offset - target) * 15

func set_focus_to(location:Vector2):
	zoom = self.focus_on 
	var target = viewport_transform * location
	offset = viewport_offset - (viewport_offset - target) * 15
