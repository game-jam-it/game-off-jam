extends Control

signal actor_selected

onready var _player_info = $PlayerInfoBox


func _ready():
	pass


func enable():
	visible = true

func disable():
	visible = false

func initialize():
	if visible:
		return
	visible = true
	# TODO Character selection
	emit_signal("actor_selected")
