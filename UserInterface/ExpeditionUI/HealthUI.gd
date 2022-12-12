extends Control

var hearts = 1 setget set_hearts
var max_hearts = 1 setget set_max_hearts

const heart_texture_width = 26+8 # 26 for heart 8 pixels between next heart

onready var hearts_full_ui = $HeartsFullTexture
onready var hearts_empty_ui = $HeartsEmptyTexture

func set_hearts(value: int) -> void:
	hearts = value
	
	# Confirm the nodepath is correct to prevent crashing
	if hearts_full_ui is Node:
		hearts_full_ui.rect_size.x = hearts * heart_texture_width

func set_max_hearts(value: int) -> void:
	max_hearts = max(value, 1)
	
	if hearts_empty_ui is Node:
		hearts_empty_ui.rect_size.x = max_hearts * heart_texture_width

func _ready() -> void:
	# Use self to call the setter methods
	self.max_hearts = PlayerStats.max_hearts
	self.hearts = PlayerStats.current_hearts
	
	PlayerStats.connect("max_hearts_changed", self, "on_max_hearts_changed")
	PlayerStats.connect("hearts_changed", self, "on_hearts_changed")

func on_hearts_changed(value: int) -> void:
	set_hearts(value)

func on_max_hearts_changed(value: int) -> void:
	set_max_hearts(value)
