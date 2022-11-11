extends Camera2D

var panning = false

var zoom_in = Vector2(1.0, 1.0)
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
	var viewport_size = get_viewport().size
	var previous_zoom = zoom

	# TODO: Store old offset when zooming in and restore it
	if zoom.x > zoom_in.x: 
		var target = get_viewport_transform() * location
		offset += ((viewport_size * 0.5) - target) * (self.zoom_in-previous_zoom)
		zoom_out = self.zoom
		zoom = self.zoom_in 
	else: 
		offset = viewport_size * 0.5
		zoom = self.zoom_out
