extends VBoxContainer

signal actor_hover(info)
signal actor_selected(info)

var _info = {
	"active": true,
	"name": "Unknown"
}

onready var actor_rect = get_node("%ActorRect")
onready var actor_label = get_node("%ActorLabel")

func _ready():
	self.connect("gui_input", self, "on_gui_input")
	self.connect("mouse_exited", self, "on_mouse_exited")
	self.connect("mouse_entered", self, "on_mouse_entered")

func set_info(info):
	self._info = info
	actor_rect = get_node("%ActorRect")
	actor_label = get_node("%ActorLabel")
	actor_rect.flip_h = info.flip
	actor_rect.texture = info.texture
	if info.active: _set_as_active()
	else: _set_as_inactive()

func on_mouse_exited():
	emit_signal("actor_hover", null)
	if _info.active: 
		actor_rect.modulate = Color(0.9, 0.9, 0.9)
		actor_label.modulate = Color(0.68, 0.68, 0.68)
	else: 
		actor_rect.modulate = Color(0.38, 0.38, 0.38)
		actor_label.modulate = Color(0.48, 0.48, 0.48)

func on_mouse_entered():
	emit_signal("actor_hover", _info)
	if _info.active: 
		actor_rect.modulate = Color(1.0, 1.0, 1.0)
		actor_label.modulate = Color(0.88, 0.88, 0.88)
	else: 
		actor_rect.modulate = Color(0.48, 0.48, 0.48)
		actor_label.modulate = Color(0.58, 0.58, 0.58)

func on_gui_input(event):  
	if event is InputEventMouseButton and event.doubleclick:
		emit_signal("actor_selected", _info)

func _set_as_active():
	actor_rect.modulate = Color(0.9, 0.9, 0.9)
	actor_label.modulate = Color(0.68, 0.68, 0.68)
	actor_label.text = _info.name

func _set_as_inactive():
	actor_rect.modulate = Color(0.38, 0.38, 0.38)
	actor_label.modulate = Color(0.48, 0.48, 0.48)
	actor_label.text = "Soon™"
