extends Node2D

const PI2 = PI*2
const SIZE = 12

var color = Color(0.28, 0.28, 0.28)
var coords = Vector2.ZERO

func _process(_delta):
	update()

func _draw():
	draw_arc(Vector2(0, 0), SIZE, 0, PI2, 32, color, 4)

func set_color(value:Color):
	color = value
	$HexSprite.modulate = value

func set_coords(value:Vector2):
	coords = value
	position = value
