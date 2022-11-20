extends MarginContainer

onready var _info_box = get_node("%InfoBox")

onready var _name_label = get_node("%NameValue")
onready var _index_label = get_node("%IndexValue")

onready var _health_label = get_node("%HealthValue")
onready var _portrait_texture = get_node("%PortraitTexture")

var _portrait_default = preload("res://UserInterface/assets/portrait_default_flip.png")


func _ready():
	_name_label.text = "Unknown"
	_index_label.text = " (0) "
	_health_label.text = "0/0"
	_portrait_texture.texture = _portrait_default
	_info_box.connect("gui_input", self, "on_gui_input")
	_info_box.connect("mouse_exited", self, "on_mouse_exited")
	_info_box.connect("mouse_entered", self, "on_mouse_entered")

func initialize(_enemy):
	# TODO Initialize enemy box
	pass


func on_mouse_exited():
	print("Mouse Exited %s" % name)

func on_mouse_entered():
	print("Mouse Entered %s" % name)

func on_gui_input(event):  
	if event is InputEventMouseButton and event.doubleclick:
		print("Mouse Double Clicked %s" % name)

func on_health_updated(_value):
	var max_hearts = ActorStats.max_hearts
	var current_hearts = ActorStats.current_hearts
	_health_label.text = " %s/%s " % [current_hearts, max_hearts]
