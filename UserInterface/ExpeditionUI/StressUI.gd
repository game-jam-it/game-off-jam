extends Control

var current_stress: int = 0 setget set_current_stress
var max_stress: int = 6

const stress_segment_texture_width: int = 23

onready var stress_segment_ui = $StressSegmentTexture

func set_current_stress(value: int) -> void:
	current_stress = value
	
	if stress_segment_ui is Node:
		stress_segment_ui.rect_size.x = current_stress * stress_segment_texture_width

func _ready() -> void:
	# Use self to call the setter methods
	self.current_stress = ActorStats.current_stress
	max_stress = ActorStats.max_stress
	
	ActorStats.connect("stress_changed", self, "on_stress_changed")
	ActorStats.connect("max_stress_changed", self, "on_max_stress_changed")

func on_stress_changed(value: int) -> void:
	set_current_stress(value)

func on_max_stress_changed(value: int) -> void:
	max_stress = value
