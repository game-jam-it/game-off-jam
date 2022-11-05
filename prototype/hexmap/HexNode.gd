extends Node2D

const PI2 = PI*2
const SIZE = 24

func _ready():
	pass # Replace with function body.

func _process(_delta):
	update()

func _draw():
	draw_arc(Vector2(position.x, position.y), SIZE, 0, PI2, 32, Color(0.23, 0.23, 0.23), 2)
