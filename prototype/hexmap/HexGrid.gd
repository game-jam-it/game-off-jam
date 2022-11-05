extends Reference

var HexCell = preload("./HexCell.gd")

var hex_size
var hex_transform
var hex_transform_inv

var path_barriers = {}
var path_obstacles = {}

var view_obstacles = {}

var path_bounds = Rect2()
var path_cost_default = 1.0

# Allow the user to scale the hex for fake perspective or somesuch
export(Vector2) var hex_scale = Vector2(1, 1) setget set_hex_scale

func _init():
	set_hex_scale(hex_scale)

func set_hex_scale(scale:Vector2):
	hex_scale = scale
	hex_size = HexCell.SIZE * hex_scale
	hex_transform = Transform2D(
		Vector2(hex_size.x * 3/4, -hex_size.y / 2),
		Vector2(0, -hex_size.y),
		Vector2(0, 0)
	)
	hex_transform_inv = hex_transform.affine_inverse()


"""
	Converting between hex-grid and 2D coordinates
"""

func get_hex_center(hex):
	# Returns centre of the hex
	return hex_transform * hex.get_axial_coords()

func get_hex_center_for(obj):
	# Returns centre of the hex for
	var node = HexCell.new(obj)
	return hex_transform * node.get_axial_coords()

"""
	Pathfinding Utilities
"""

func set_bounds(min_coords, max_coords):
	# Set the absolute bounds of the pathfinding area in grid coords
	# The given coords will be inside the boundary (hence the extra (1, 1))
	min_coords = HexCell.new(min_coords).get_axial_coords()
	max_coords = HexCell.new(max_coords).get_axial_coords()
	path_bounds = Rect2(min_coords, (max_coords - min_coords) + Vector2(1, 1))

func get_path_obstacles():
	return path_obstacles
	
func add_path_obstacles(vals, cost=0):
	# Store the given coordinate/s as obstacles
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	for coords in vals:
		coords = HexCell.new(coords).get_axial_coords()
		path_obstacles[coords] = cost

func remove_path_obstacles(vals):
	# Remove the given obstacle/s from the grid
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	for coords in vals:
		coords = HexCell.new(coords).get_axial_coords()
		path_obstacles.erase(coords)

func get_path_barriers():
	return path_barriers

func add_path_barriers(vals, dirs, cost=0):
	# Store the given directions of the given locations as barriers
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	if not typeof(dirs) == TYPE_ARRAY:
		dirs = [dirs]
	for coords in vals:
		coords = HexCell.new(coords).get_axial_coords()
		var barriers = {}
		if coords in path_barriers:
			# Already something there
			barriers = path_barriers[coords]
		else:
			path_barriers[coords] = barriers
		# Set or override the given dirs
		for dir in dirs:
			barriers[dir] = cost
		path_barriers[coords] = barriers
	
func remove_path_barriers(vals, dirs=null):
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	if dirs != null and not typeof(dirs) == TYPE_ARRAY:
		dirs = [dirs]
	for coords in vals:
		coords = HexCell.new(coords).get_axial_coords()
		if dirs == null:
			path_barriers.erase(coords)
		else:
			for dir in dirs:
				path_barriers[coords].erase(dir)

func get_path_hex_cost(coords):
	# Returns the cost of moving to the given hex
	coords = HexCell.new(coords).get_axial_coords()
	if coords in path_obstacles:
		return path_obstacles[coords]
	if not path_bounds.has_point(coords):
		# Out of bounds
		return 0
	return path_cost_default
	
func get_path_move_cost(coords, direction):
	# Returns the cost of moving from one hex to a neighbour
	direction = HexCell.new(direction).get_cube_coords()
	var start_hex = HexCell.new(coords)
	var target_hex = HexCell.new(start_hex.get_cube_coords() + direction)
	coords = start_hex.axial_coords
	# First check if either end is completely impassable
	var cost = get_path_hex_cost(start_hex)
	if cost == 0:
		return 0
	cost = get_path_hex_cost(target_hex)
	if cost == 0:
		return 0
	# Check for barriers
	var barrier_cost
	if coords in path_barriers and direction in path_barriers[coords]:
		barrier_cost = path_barriers[coords][direction]
		if barrier_cost == 0:
			return 0
		cost += barrier_cost
	var target_coords = target_hex.axial_coords
	if target_coords in path_barriers and -direction in path_barriers[target_coords]:
		barrier_cost = path_barriers[target_coords][-direction]
		if barrier_cost == 0:
			return 0
		cost += barrier_cost
	return cost

func find_path(start, goal, exceptions=[]):
	# Light a starry path from the start to the goal, inclusive
	start = HexCell.new(start).get_axial_coords()
	goal = HexCell.new(goal).get_axial_coords()
	# Make sure all the exceptions are axial coords
	var exc = []
	for ex in exceptions:
		exc.append(HexCell.new(ex).get_axial_coords())
	exceptions = exc
	# Now we begin the A* search
	var frontier = [make_priority_item(start, 0)]
	var came_from = {start: null}
	var cost_so_far = {start: 0}
	while not frontier.empty():
		var current = frontier.pop_front().v
		if current == goal:
			break
		for next_hex in HexCell.new(current).get_all_adjacent():
			var next = next_hex.axial_coords
			var next_cost = get_path_move_cost(current, next - current)
			if next == goal and (next in exceptions or get_path_hex_cost(next) == 0):
				# Our goal is an obstacle, but we're next to it
				# so our work here is done
				came_from[next] = current
				frontier.clear()
				break
			if not next_cost or next in exceptions:
				# We shall not pass
				continue
			next_cost += cost_so_far[current]
			if not next in cost_so_far or next_cost < cost_so_far[next]:
				# New shortest path to that node
				cost_so_far[next] = next_cost
				var priority = next_cost + next_hex.distance_to(goal)
				# Insert into the frontier
				var item = make_priority_item(next, priority)
				var idx = frontier.bsearch_custom(item, self, "comp_priority_item")
				frontier.insert(idx, item)
				came_from[next] = current
	
	if not goal in came_from:
		# Not found
		return []

	# Follow the path back where we came_from
	var path = []
	if not (get_path_hex_cost(goal) == 0 or goal in exceptions):
		# Only include the goal if it's traversable
		path.append(HexCell.new(goal))
	var current = goal
	while current != start:
		current = came_from[current]
		path.push_front(HexCell.new(current))
	return path

# Used to make a priority queue out of an array
func make_priority_item(val, priority):
	return {"v": val, "p": priority}

func comp_priority_item(a, b):
	return a.p < b.p

"""
	Field of view Utilities
"""

func get_view_obstacles():
	return path_obstacles
	
func add_view_obstacles(vals, cost=0):
	# Store the given coordinate/s as obstacles
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	for coords in vals:
		coords = HexCell.new(coords).get_axial_coords()
		path_obstacles[coords] = cost

func remove_view_obstacles(vals):
	# Remove the given obstacle/s from the grid
	if not typeof(vals) == TYPE_ARRAY:
		vals = [vals]
	for coords in vals:
		coords = HexCell.new(coords).get_axial_coords()
		path_obstacles.erase(coords)

func get_line_of_sight(_start, _target):
	# Returns a vector from start to target
	# TODO Draw Line and check every hex along the way
	pass

func has_line_of_sight(_start, _target, _exceptions=[]):
	# TODO Draw Line and check every hex along the way
	pass
