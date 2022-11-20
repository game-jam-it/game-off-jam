extends MarginContainer

onready var _info_box = get_node("%InfoBox")

onready var _map_name_label = get_node("%MapNameValue")
onready var _objective_label = get_node("%ObjectiveValue")


func _ready():
	_map_name_label.text = "Unknown"
	_objective_label.text = "0/0"
	_info_box.connect("gui_input", self, "on_gui_input")
	_info_box.connect("mouse_exited", self, "on_mouse_exited")
	_info_box.connect("mouse_entered", self, "on_mouse_entered")

func initialize(_map):
	# TODO Initialize map box
	pass


func on_mouse_exited():
	print("Mouse Exited %s" % name)

func on_mouse_entered():
	print("Mouse Entered %s" % name)

func on_gui_input(event):  
	if event is InputEventMouseButton and event.doubleclick:
		print("Mouse Double Clicked %s" % name)
