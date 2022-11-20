extends Control

onready var _info_box = get_node("%InfoBox")

onready var _health_label = get_node("%HealthValue")
onready var _stress_label = get_node("%StressValue")
onready var _portrait_texture = get_node("%PortraitTexture")

var _portrait_default = preload("res://UserInterface/assets/portrait_default.png")


func _ready():
	_health_label.text = " 0/0 "
	_stress_label.text = " 0/0 "
	_portrait_texture.texture = _portrait_default
	_info_box.connect("gui_input", self, "on_gui_input")
	_info_box.connect("mouse_exited", self, "on_mouse_exited")
	_info_box.connect("mouse_entered", self, "on_mouse_entered")
	ActorStats.connect("hearts_changed", self, "on_health_updated")
	ActorStats.connect("max_hearts_changed", self, "on_health_updated")
	ActorStats.connect("stress_changed", self, "on_stress_updated")
	ActorStats.connect("max_stress_changed", self, "on_stress_updated")
	ActorStats.connect("character_changed", self, "on_character_updated")


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

func on_stress_updated(_value):
	var max_stress = ActorStats.max_stress
	var current_stress = ActorStats.current_stress
	_stress_label.text = " %s/%s " % [current_stress, max_stress]

func on_character_updated(_character):
	_portrait_texture.texture = ActorStats.character.portrait_base
