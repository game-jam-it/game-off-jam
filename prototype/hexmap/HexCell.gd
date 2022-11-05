extends Resource

const SIZE = Vector2(1, sqrt(3)/2)

# Directions to neighbouring cells
const DIR_N = Vector3(0, 1, -1)
const DIR_NE = Vector3(1, 0, -1)
const DIR_SE = Vector3(1, -1, 0)
const DIR_S = Vector3(0, -1, 1)
const DIR_SW = Vector3(-1, 0, 1)
const DIR_NW = Vector3(-1, 1, 0)
const DIR_ALL = [DIR_N, DIR_NE, DIR_SE, DIR_S, DIR_SW, DIR_NW]

var q: int
var r: int

func _init(_q: int, _r: int):
	assert((_q + _r + (-_q-_r)) < 0.001)
	self.q = _q
	self.r = _r

func _new_cell(vec: Vector3):
	assert((vec.x + vec.y + vec.z) < 0.001)
	return get_script().new(vec.x, vec.y)

"""
	Coords Utilities
"""

func get_cube_coords():
	return Vector3(q, r, (-q-r))

func _round_coords(vec):
	var o = Vector3(round(vec.x), round(vec.y), round(vec.z))
	var d = (o - vec).abs()
	if d.x > d.y and d.x > d.z:
		o.x = -o.y - o.z
	elif d.y > d.z:
		o.y = -o.x - o.z
	else:
		o.z = -o.x - o.y
	return o

"""
	Pathfinding Utilities
"""

func line_to(target):
	var to = target.get_cube_coords()
	var from = self.get_cube_coords()
	var nudge = to + Vector3(1e-6, 2e-6, -3e-6)
	var steps = int((abs(to.x - from.x) + abs(to.y - from.y) + abs(to.z - from.z)) / 2)
	var path = []
	for dist in range(steps):
		var vec = to.linear_interpolate(nudge, float(dist) / steps)
		path.append(_new_cell(_round_coords(vec)))
	path.append(target)
	return path

func distance_to(target):
	var to = target.get_cube_coords()
	var from = self.get_cube_coords()
	return int((abs(to.x - from.x) + abs(to.y - from.y) + abs(to.z - from.z)) / 2)

"""
	Neighbouring Utilities
"""

func get_adjacent(dir):
	if typeof(dir) == TYPE_VECTOR2:
		dir = Vector3(dir.x, dir.y, (-dir.x-dir.y))
	return _new_cell(self.get_cube_coords() + dir)

func get_all_adjacent():
	var nodes = Array()
	var coords = self.get_cube_coords()
	for dir in DIR_ALL:
		var node = coords + dir
		nodes.append(get_script().new(node.x, node.y, node.z))
	return nodes

func get_all_within(distance):
	var nodes = Array()
	for dx in range(-distance, distance+1):
		for dy in range(max(-distance, -distance - dx), min(distance, distance - dx) + 1):
			var coords = self.get_cube_coords() + Vector3(dx, dy, (-dx - dy))
			nodes.append(_new_cell(coords))
	return nodes

func get_node_ring_for(distance):
	var coords = self.get_cube_coords()

	if distance < 1:
		return [_new_cell(coords)]
	
	var nodes = Array()
	var current = _new_cell(coords + (DIR_N * distance))
	for dir in [DIR_SE, DIR_S, DIR_SW, DIR_NW, DIR_N, DIR_NE]:
		for _step in range(distance):
			nodes.append(current)
			current = current.get_adjacent(dir)
	return nodes
