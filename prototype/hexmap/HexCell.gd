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

var _q: int
var _r: int

#func _init(q: int = 0, r: int = 0, s: int = 0):
func _init(obj = null):
	var coords = self.get_coords_for(obj)
	assert((coords.x + coords.y + coords.z) < 0.001)
	self._q = coords.x
	self._r = coords.y

func q():
	return _q

func r():
	return _r

func s():
	return -_q-_r

func get_node_for(obj):
	# Returns a new instance
	if typeof(obj) == TYPE_VECTOR3:
		return get_script().new(Vector3(obj.x, obj.y, obj.z))
	elif typeof(obj) == TYPE_VECTOR2:
		return get_script().new(Vector3(obj.x, obj.y, (-obj.x-obj.y)))
	elif typeof(obj) == TYPE_OBJECT and obj.has_method("get_cube_coords"):
		var coords =  obj.get_cube_coords()
		return get_script().new(coords)

func get_coords_for(obj):
	# Returns a new Vector3
	if typeof(obj) == TYPE_VECTOR3:
		return obj
	elif typeof(obj) == TYPE_VECTOR2:
		return Vector3(obj.x, obj.y, (-obj.x-obj.y))
	elif typeof(obj) == TYPE_OBJECT and obj.has_method("get_cube_coords"):
		return  obj.get_cube_coords()

func round_coords(vec):
	# Returns a new Vector3
	if typeof(vec) == TYPE_VECTOR2:
		vec = Vector3(vec.x, vec.y, (-vec.x-vec.y))
	
	# Round the values them and then recalculate to `x + y + z = 0`
	var rounded = Vector3(round(vec.x), round(vec.y), round(vec.z))

	# Recalculate it to be 'x + y + z = 0'
	var diffs = (rounded - vec).abs()
	if diffs.x > diffs.y and diffs.x > diffs.z:
		rounded.x = -rounded.y - rounded.z
	elif diffs.y > diffs.z:
		rounded.y = -rounded.x - rounded.z
	else:
		rounded.z = -rounded.x - rounded.y
	
	return rounded

func get_cube_coords():
	return Vector3(_q, _r, (-_q-_r))

func get_axial_coords():
	return Vector2(_q, _r)

func get_offset_coords():
	var x = int(_q) - (int(_q) & 1)
	var off_y = int(_r) + x / 2
	return Vector2(x, off_y)

"""
	Pathfinding Utilities
"""

func line_to(target):
	var to = get_coords_for(target)
	var nudge = to + Vector3(1e-6, 2e-6, -3e-6)
	var steps = distance_to(to)
	var path = []
	for dist in range(steps):
		var vec = to.linear_interpolate(nudge, float(dist) / steps)
		path.append(get_node_for(round_coords(vec)))
	path.append(get_node_for(target))
	return path

func distance_to(target):
	var to = get_coords_for(target)
	var from = get_cube_coords()
	return int((abs(to.x - from.x) + abs(to.y - from.y) + abs(to.z - from.z)) / 2)

"""
	Neighbouring Utilities
"""

func get_adjacent(dir):
	# Returns a HexNode instance
	if typeof(dir) == TYPE_VECTOR2:
		dir = Vector3(dir.x, dir.y, (-dir.x-dir.y))
	var coords = Vector3(_q, _r, (-_q-_r)) + dir
	return get_script().new(coords.x, coords.y, coords.z)

func get_all_adjacent():
	# Returns an array of HexNode instances representing adjacent locations
	var nodes = Array()
	var coords = Vector3(_q, _r, (-_q-_r))
	for dir in DIR_ALL:
		var node = coords + dir
		nodes.append(get_script().new(node.x, node.y, node.z))
	return nodes

func get_all_within(distance):
	# Returns an array of all HexNode instances within the given distance
	var nodes = Array()
	for dx in range(-distance, distance+1):
		for dy in range(max(-distance, -distance - dx), min(distance, distance - dx) + 1):
			var vec = Vector2(_q+dx, _r+dy)
			nodes.append(get_script().new(vec.x, vec.y, (-vec.x-vec.y)))
	return nodes

func get_node_ring_for(distance):
	var coords = Vector3(_q, _r, (-_q-_r))
	# Returns an array of all HexNode instances at the given distance
	if distance < 1:
		return [get_script().new(coords.x, coords.y, coords.z)]
	# Start at the top (+y) and walk in a clockwise circle
	var nodes = Array()
	var current = get_node_for(coords + (DIR_N * distance))
	for dir in [DIR_SE, DIR_S, DIR_SW, DIR_NW, DIR_N, DIR_NE]:
		for _step in range(distance):
			nodes.append(current)
			current = current.get_adjacent(dir)
	return nodes
