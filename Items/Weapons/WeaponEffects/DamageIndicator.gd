extends Node2D

export(int) var speed: int = 20
var move_direction: Vector2 = Vector2.ZERO
var damage: int = 0
var color: Color = Color.crimson

onready var damage_label = $Label

func _ready():
	move_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	damage_label.text = str(damage)
	damage_label.set("custom_colors/font_color", color)

func _process(delta):
	global_position += speed * move_direction * delta
