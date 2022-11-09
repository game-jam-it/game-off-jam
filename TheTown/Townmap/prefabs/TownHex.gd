class_name TownHexNode
extends Node2D

const PI2 = PI*2
const SIZE = 32

var color = Color(0.28, 0.28, 0.28)

var coords = Vector2.ZERO
var location = Vector2.ZERO

func _process(_delta):
	update()

func _draw():
	if !TheTown.draw_debug:
		return

	draw_arc(Vector2(0, 0), SIZE, 0, PI2, 32, color, 8)

func set_color(value:Color):
	color = value

func set_coords(value:Vector2):
	var grid = TheTown.get_grid()
	coords = value
	location = grid.get_location(value)
	self.position = location

func set_location(value:Vector2):
	var grid = TheTown.get_grid()
	coords = grid.get_coords(value)
	location = value
	self.position = value