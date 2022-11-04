extends Control

onready var label = $Label

func _ready():
	GameSettings.connect("show_fps", self, "_on_show_fps")
	label.visible = GameSettings.data.fps

func _process(_delta):
	label.text = "FPS: %s" % [Engine.get_frames_per_second()]

func _on_show_fps(value):
	label.visible = value
