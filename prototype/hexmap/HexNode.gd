extends Node2D

const PI2 = PI*2

var size = 24
var color = Color(0.23, 0.23, 0.23)

func _ready():
	pass # Replace with function body.

func _process(_delta):
	update()

func _draw():
	draw_arc(Vector2(0, 0), size, 0, PI2, 32, color, 2)
