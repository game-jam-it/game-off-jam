extends Camera2D

var panning = false

var zoom_in = Vector2(1.0, 1.0)
var focus_on = Vector2(7.5, 7.5)
var zoom_out = Vector2(15.0, 15.0)

func _input(event):
	if event.is_action_pressed("mouse_pan"):
		panning = true
	elif event.is_action_released("mouse_pan"):
		panning = false
	if panning == true && event is InputEventMouseMotion:
		offset -= event.relative * zoom

func zoom_reset():
	offset = get_viewport().size * 0.5
	zoom = self.zoom_out

func zoom_to(location:Vector2):
	var target = get_viewport_transform() * location
	offset = get_viewport().size * 0.5
	offset -= (offset - target) * 15.0 * 2.0
	zoom = self.zoom_in

func focus_on(location:Vector2):
	var target = get_viewport_transform() * location
	offset = get_viewport().size * 0.5
	offset -= (offset - target) * 7.5 * 1.5
	zoom = self.focus_on 
