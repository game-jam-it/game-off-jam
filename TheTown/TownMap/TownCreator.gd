class_name TownCreator
extends Node2D

var is_done = false
var is_working = false

var seed_phrase = "Godot Rocks"

var grid: TownGrid

var nodes: TownNodes
var events: TownEvents

var rng: RandomNumberGenerator

const MIN_SIZE =  5
const MAX_SIZE = 15

const TILE_SIZE = 64
const CULL_TARGET = 0.20


# FixMe: These maps are a hack
# Clean linked resources in godot?
var mapped = {}


func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash(seed_phrase)


"""
	Loads a layout to TheTown
"""

func load_town(_key:String):
	if is_working: 
		return false

	is_done = false
	is_working = true

	rng = RandomNumberGenerator.new()
	# TODO Load General Info
	# load seed_phrase
	# load rng.state
	# load rng.seed

	grid = TheTown.get_grid()
	nodes = TheTown.get_nodes()
	events = TheTown.get_events()

	yield(_load_nodes(), "completed")
	yield(_load_paths(), "completed")
	yield(_load_roads(), "completed")

	yield(_draw_roads(nodes.road), "completed")
	yield(_draw_paths(nodes.path), "completed")
	yield(_draw_nodes(nodes.get_children()), "completed")

	is_working = false
	is_done = true

	return true

func _load_nodes():
	if !is_working: 
		return
		#TODO Implement
	yield(get_tree(), "idle_frame")

func _load_paths():
	if !is_working: 
		return
		#TODO Implement
	yield(get_tree(), "idle_frame")

func _load_roads():
	if !is_working: 
		return
		#TODO Implement
	yield(get_tree(), "idle_frame")


"""
	Saves the layout from TheTown
"""

func save_town(_key:String):
	if is_working: 
		return false

	is_done = false
	is_working = true

	# TODO Save General Info
	# save seed_phrase
	# save rng.state
	# save rng.seed

	yield(_save_nodes(), "completed")
	yield(_save_paths(), "completed")
	yield(_save_roads(), "completed")

	is_working = false
	is_done = true

	return true

func _save_nodes():
	if !is_working: 
		return
		#TODO Implement
	yield(get_tree(), "idle_frame")

func _save_paths():
	if !is_working: 
		return
		#TODO Implement
	yield(get_tree(), "idle_frame")

func _save_roads():
	if !is_working: 
		return
		#TODO Implement
	yield(get_tree(), "idle_frame")


"""
	Creates a random layout for TheTown
"""

# Generate a town map, default cfg set as small map
func create_town(_seed_phrase:String, cfg = {
	"zoom": 20,
	"nodes": 96,
	"culler": 0.25,
	"spread": Vector2(160.0, 20.0),
	"grid_size": Vector2(620.0, 40.0),
	"center": 5120000,
	"center_offset": 384,
	"outer": 12800000,
	"outer_offset": 512,
	"edge": 51200000,
	"edge_offset": 768,
}):
	if is_working:
		return false

	is_done = false
	is_working = true

	mapped = Events.build_maps()

	rng = RandomNumberGenerator.new()
	rng.seed = hash(_seed_phrase)
	seed_phrase = _seed_phrase

	grid = TheTown.get_grid()
	nodes = TheTown.get_nodes()
	events = TheTown.get_events()

	grid.clear()
	nodes.clear()
	events.clear()

	grid.reset_size(cfg.grid_size)

	var list = yield(_create_nodes(cfg), "completed")
	nodes.path = yield(_create_path(list), "completed")
	nodes.road = yield(_create_road(nodes.path), "completed")
	
	yield(_draw_roads(nodes.road), "completed")
	yield(_draw_paths(nodes.path), "completed")
	yield(_draw_nodes(nodes.get_children()), "completed")

	print("Create Town: Nodes: %s | Path: %s | Road: %s" % [
		nodes.get_children().size(), 
		nodes.path.get_points().size(), 
		nodes.road.get_points().size()
	])
	is_working = false
	is_done = true

	return true

# Returns a list of all positions
func _create_nodes(cfg):
	if !is_working:
		return []

	# Create town event nodes
	for _idx in range(cfg.nodes):
		var rad = 1 + (rng.randi() % 4)
		nodes.create(rad, TILE_SIZE, Vector2(
			rng.randf_range(-cfg.spread.x, cfg.spread.x),
			rng.randf_range(-cfg.spread.y, cfg.spread.y)
		))
	yield(get_tree().create_timer(1.2), 'timeout')

	# Set regions and snap to grid
	var list = []
	for node in nodes.get_children():
		node.mode = RigidBody2D.MODE_STATIC
		yield(get_tree(), "idle_frame")
		# Note: Yield is required to lock physics 
		node.set_coords(grid.get_coords(node.position))
		# Uses Position as location is not updated by physics
		var dist = node.location.distance_squared_to(Vector2.ZERO)
		if dist < cfg.center:
			_set_node_region(TownNode.Type.Center, cfg.culler * 0.6, node, list)
		elif dist < cfg.outer:
			if abs(node.position.y) < cfg.center_offset:
				_set_node_region(TownNode.Type.Center, cfg.culler * 0.8, node, list)
			else:
				_set_node_region(TownNode.Type.Outskirt, cfg.culler * 1.2, node, list)
		elif dist < cfg.edge && abs(node.position.y) < cfg.outer_offset:
			_set_node_region(TownNode.Type.Outskirt, cfg.culler * 1.6, node, list)
		else:
			_set_node_region(TownNode.Type.Country, cfg.culler * 2.0, node, list)
	yield(get_tree(), "idle_frame")
	return list

# Returns a spanning tree of 
# all positions an AStar object
func _create_path(list):
	if !is_working: return AStar.new()
	yield(get_tree(), "idle_frame")
	return _run_prims_algo(list)

# Returns a spanning tree for the
# main road nodes as an AStar object
func _create_road(tree: AStar):
	if !is_working: 
		return

	var min_n = null
	var min_x = 0
	var max_n = null
	var max_x = 0
	## TODO: Optimize, this can be combined
	## as _create_nodes uses the same loop 
	## to snap the positions to a hexmap
	for n in nodes.get_children():
		if n.position.x < min_x:
			min_n = n.position
			min_x = n.position.x
		if n.position.x > max_x:
			max_n = n.position
			max_x = n.position.x

	var min_i = tree.get_available_point_id()
	var min_p = tree.get_closest_point(Vector3(min_n.x, min_n.y, 0))
	tree.add_point(min_i, Vector3(min_n.x * 3, min_n.y * 1.25, 0))
	tree.connect_points(min_i, min_p)

	var max_i = tree.get_available_point_id()
	var max_p = tree.get_closest_point(Vector3(max_n.x, max_n.y, 0))
	tree.add_point(max_i, Vector3(max_n.x * 3, max_n.y * 1.25, 0))
	tree.connect_points(max_i, max_p)

	var list = []
	var path = tree.get_id_path(min_i, max_i)
	for id in path: list.append(tree.get_point_position(id))

	yield(get_tree(), "idle_frame")
	return _run_prims_algo(list)

# Runs prim's algorithm to create
# a spanning tree for the positions
func _run_prims_algo(positions):
	var tree = AStar.new()
	tree.add_point(
		tree.get_available_point_id(), 
		positions.pop_front()
	)
	# Repeat until all nodes are connected
	while positions:
		var p = null  			# Current position
		var min_p = null  	# Minimum position
		var min_dist = INF  # Minimum distance
		for pa in tree.get_points():
			pa = tree.get_point_position(pa)
			for pb in positions:
				if pa.distance_to(pb) < min_dist:
					min_dist = pa.distance_to(pb)
					min_p = pb
					p = pa

		var id = tree.get_available_point_id()
		tree.add_point(id, min_p)
		var pd = tree.get_closest_point(p)
		tree.connect_points(pd, id)
		positions.erase(min_p)
	return tree

func _set_node_region(type, cull, node, list):
	if rng.randf() < cull:
		node.queue_free()
		return
	node.type = type
	if type == TownNode.Type.Center:
		## Add to center nodes
		node.set_colors(
			Color(0, 0.60, 0.60),
			Color(0, 0.85, 0.85)
		)
	elif type == TownNode.Type.Outskirt:
		## Add to outskirt nodes
		node.set_colors(
			Color(0, 0.40, 0.40),
			Color(0, 0.75, 0.75)
		)
	elif type == TownNode.Type.Country:
		## Add to country nodes
		node.set_colors(
			Color(0, 0.20, 0.20),
			Color(0, 0.55, 0.55)
		)
	list.append(Vector3(node.position.x, node.position.y, 0))


"""
	Renders the town layout to TheTown
"""

func _draw_nodes(list:Array):
	if !is_working: 
		return
	for node in list:
		## TODO Select node type and render
		grid.draw_node(node.position, node.size)
		match node.type:
			TownNode.Type.None:
				_add_empty_node(node)
			TownNode.Type.Center:
				_add_center_node(node)
			TownNode.Type.Country:
				_add_country_node(node)
			TownNode.Type.Outskirt:
				_add_outskirt_node(node)
		yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")


func _draw_paths(path:AStar):
	if !is_working: 
		return
	for from in path.get_points():
		var from_position = path.get_point_position(from)
		for to in path.get_point_connections(from):
			var to_position = path.get_point_position(to)
			if grid.draw_path(from_position, to_position):
				yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

func _draw_roads(road:AStar):
	if !is_working: 
		return
	for from in road.get_points():
		var from_position = road.get_point_position(from)
		for to in road.get_point_connections(from):
			var to_position = road.get_point_position(to)
			if grid.draw_road(from_position, to_position):
				yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")


func _add_empty_node(node):
	#print("Free: %s - %s" % [node.radius, node.size])
	node.queue_free()
	# TODO Fill out map for roads and travel events


func _add_center_node(node):
	if not mapped.center.has(node.radius):
		_add_empty_node(node)
		return
	var list = mapped.center[node.radius]
	if list.empty():
		_add_empty_node(node)
		return
	var info = list.pop_front()
	nodes.events[node.coords] = info
	#nodes.center_event[node.coords] = info
	var scn = info.scene.instance()
	scn.position = node.position
	events.add_child(scn)
	events.scenes[node.coords] = scn
	print("Center: %s on: %s" % [info.name, node.radius])


func _add_country_node(node):
	if not mapped.country.has(node.radius):
		_add_empty_node(node)
		return
	var list = mapped.country[node.radius]
	if list.empty():
		_add_empty_node(node)
		return
	var info = list.pop_front()
	nodes.events[node.coords] = info
	#nodes.country_event[node.coords] = info
	var scn = info.scene.instance()
	scn.position = node.position
	events.add_child(scn)
	events.scenes[node.coords] = scn
	print("Country: %s on: %s" % [info.name, node.radius])


func _add_outskirt_node(node):
	if not mapped.outskirt.has(node.radius):
		_add_empty_node(node)
		return
	var list = mapped.outskirt[node.radius]
	if list.empty():
		_add_empty_node(node)
		return
	var info = list.pop_front()
	nodes.events[node.coords] = info
	#nodes.outskirt_event[node.coords] = info
	var scn = info.scene.instance()
	scn.position = node.position
	events.add_child(scn)
	events.scenes[node.coords] = scn
	print("Outskirt: %s on: %s" % [info.name, node.radius])
