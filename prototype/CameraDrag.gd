extends Camera2D

# var mouse_start_pos
# var screen_start_position

# var dragging = false

var zoom_in = Vector2(0.5, 0.5)
var zoom_out = Vector2(15.0, 15.0)

var panning = false

func _input(event):
	# if event.is_action("mouse_right"):
	# 	if event.is_pressed():
	# 		mouse_start_pos = event.position
	# 		screen_start_position = position
	# 		dragging = true
	# 	else:
	# 		dragging = false
	# if event is InputEventMouseMotion and dragging:
	# 	position = zoom * (mouse_start_pos - event.position) + screen_start_position
		
	if event.is_action_released('zoom_event'):
		zoom_camera(event.position)
	if event.is_action_pressed("pan_with_mouse"):
		panning = true
	elif event.is_action_released("pan_with_mouse"):
		panning = false
	if event is InputEventMouseMotion and panning == true:
		offset -= event.relative * zoom

func zoom_camera(mouse_position):
	var viewport_size = get_viewport().size
	var previous_zoom = zoom

	if zoom.x >= 1.0: 
		zoom = self.zoom_in 
		offset += ((viewport_size * 0.5) - mouse_position) * (zoom-previous_zoom)
	else: 
		zoom = self.zoom_out
		offset = viewport_size * 0.5
