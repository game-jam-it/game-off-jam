class_name HexCell
extends Object

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

func _init(value=null):
	if typeof(value) == TYPE_VECTOR2:
		value = _round_coords(Vector3(value.x, value.y, (-value.x-value.y)))
	elif typeof(value) == TYPE_VECTOR3:
		value = _round_coords(value)
	elif typeof(value) == TYPE_OBJECT and value.has_method("get_cube_coords"):
		value = value.get_cube_coords()

	assert((value.x + value.y + value.z) < 0.001)
	self.q = value.x
	self.r = value.y

func _new_cell(vec: Vector3):
	assert((vec.x + vec.y + vec.z) < 0.001)
	vec = self._round_coords(vec)
	return get_script().new(vec)

"""
	Coords Utilities
"""

func equals(other):
	if other == null: return false
	return self.q == other.q && self.r == other.r

func get_cube_coords():
	return Vector3(q, r, (-q-r))

func get_axial_coords():
	return Vector2(q, r)

func _round_coords(vec):
	if typeof(vec) == TYPE_VECTOR2:
		vec = Vector3(vec.x, vec.y, -vec.x-vec.y)
	var rv = Vector3(round(vec.x), round(vec.y), round(vec.z))

	var d = (rv - vec).abs()
	if d.x > d.y and d.x > d.z:
		rv.x = -rv.y - rv.z
	elif d.y > d.z:
		rv.y = -rv.x - rv.z
	else:
		rv.z = -rv.x - rv.y

	return rv

"""
	Pathfinding Utilities
"""

func line_to(target):
	var n = distance_to(target)
	var to = target.get_cube_coords()
	var from = self.get_cube_coords()
	var nudge = to + Vector3(1e-6, 2e-6, -3e-6)
	var path = []
	for step in range(n):
		var vec = nudge.linear_interpolate(from, float(step) / n)
		path.append(_new_cell(_round_coords(vec)))
	path.append(target)
	return path

func distance_to(target):
	if typeof(target) == TYPE_VECTOR2:
		target = _new_cell(Vector3(target.x, target.y, (-target.x-target.y)))
	elif typeof(target) == TYPE_VECTOR3:
		target = _new_cell(target)

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
		nodes.append(_new_cell(node))
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
