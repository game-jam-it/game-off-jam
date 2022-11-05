extends Node2D

var map = {}
var grid = []
var width = 0;
var height = 0;

func _ready():
	width = OS.window_size.x / 64
	width = OS.window_size.y / 64
	grid.clear()
	for x in range(width):
		grid.append([])
		for y in range(height):
			map[Vector2(x, y)] = 0
			grid[x].append(0)

