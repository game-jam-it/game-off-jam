class_name EventHex
extends Node2D

const PI2 = PI*2
const SIZE = 8

var color = Color(0.16, 0.16, 0.16)

var coords = Vector2.ZERO

func _process(_delta):
	update()

func _draw():
	if TheTown.draw_debug:
		draw_arc(Vector2(0, 0), SIZE, 0, PI2, 32, color, 2)

func set_color(value:Color):
	color = value

func set_coords(value:Vector2):
	coords = value

func set_location(value:Vector2):
	self.position = value
