extends Node2D

var min_size = 5
var max_size = 15
var tile_size = 64
var node_count = 64
var cull_target = 0.25

var x_spread = 100
var y_spread = 20

var path_all = null
var path_main = null

var is_ready = false

var NodeScene = preload("res://prototype/town-generator/TownNode.tscn")

func _ready():
	randomize()
	make_nodes()
	print_debug("Town map done")

func _draw():
	pass
	#for n in $Nodes.get_children():
	#	var r = Rect2(n.position - n.size, n.size * 2)
	#	if is_ready:
	#		draw_rect(r, Color(0, 1, 1), false)
	#	else:
	#		draw_rect(r, Color(1, 1, 0), false)
	# if path_all:
	# 	for p in path_all.get_points():
	# 		var pp = path_all.get_point_position(p)
	# 		# Distance check for back road links and paths
	# 		#draw_arc(Vector2(pp.x, pp.y), tile_size * max_size * 4, 0, PI*2, 32, Color(0.23, 0.23, 0.23), 12)
	# 		for c in path_all.get_point_connections(p):
	# 			var cp = path_all.get_point_position(c)
	# 			draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(0.5, 0.5, 0.0), 8, true)
	# if path_main:
	# 	for p in path_main.get_points():
	# 		var pp = path_main.get_point_position(p)
	# 		#draw_circle(Vector2(pp.x, pp.y), 32.0, Color(1, 0, 0))
	# 		for c in path_main.get_point_connections(p):
	# 			var cp = path_main.get_point_position(c)
	# 			draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1.0, 1.0, 0.0), 8, true)

func _input(event):
	if is_ready && event.is_action_pressed("ui_select"):
		for n in $Nodes.get_children():
			n.queue_free()
		path_all = null
		path_main = null
		make_nodes()

func _process(_delta):
	update()

func parse_node(type, cull, node, positions):
	if randf() < cull:
		node.queue_free()
	else:
		node.type = type
		node.mode = RigidBody2D.MODE_STATIC
		positions.append(Vector3(node.position.x, node.position.y, 0))

func make_nodes():
	$Grid.setup_grid()
	is_ready = false
	for _i in range(node_count):
		var p = Vector2(
			rand_range(-x_spread, x_spread), 
			rand_range(-y_spread, y_spread)
		)
		var n = NodeScene.instance()

		var r = randi() % 3
		
		if r <= 1:   n.make_node(p, Vector2(5, 5) * tile_size)
		elif r <= 2: n.make_node(p, Vector2(7, 7) * tile_size)
		elif r <= 3: n.make_node(p, Vector2(9, 9) * tile_size)
		else:        n.make_node(p, Vector2(3, 3) * tile_size)

		$Nodes.add_child(n)

	# Wait for the physics animation to end
	yield(get_tree().create_timer(0.8), 'timeout')

	# TODO On center nodes check size if max w or h split
	# TODO On center reduce culled value on outsirds increase

	var positions = []
	for n in $Nodes.get_children():
		# Note: Distance works but has some edge cases to solve
		# this a second run based on the main road adjust values.
		var distance = n.position.distance_squared_to(Vector2.ZERO)
		if distance < 1600000:
			parse_node(1, cull_target * 0.6, n, positions)
		elif distance < 6400000:
			if abs(n.position.y) < 256.0:
				parse_node(1, cull_target * 0.8, n, positions)
			else:
				parse_node(2, cull_target, n, positions)
		elif distance < 12800000 && abs(n.position.y) < 392.0:
			parse_node(2, cull_target * 1.2, n, positions)
		else:
			parse_node(3, cull_target * 1.6, n, positions)

		yield(get_tree().create_timer(0.01), 'timeout')

	path_all = run_prims_algorithm(positions)
	is_ready = true
	build_nodes()
	build_mains()
	build_grids()

# Runs prim's algorithm
# Given an array of positions it
# generates a minimum spanning tree.
# Returns an AStar object
func run_prims_algorithm(nodes):
	var star = AStar.new()
	star.add_point(star.get_available_point_id(), nodes.pop_front())
	
	# Repeat until all nodes are connected
	while nodes:
		var p = null  			# Current position
		var min_p = null  	# Minimum position
		var min_dist = INF  # Minimum distance
		for pa in star.get_points():
			pa = star.get_point_position(pa)
			for pb in nodes:
				if pa.distance_to(pb) < min_dist:
					min_dist = pa.distance_to(pb)
					min_p = pb
					p = pa

		var id = star.get_available_point_id()
		star.add_point(id, min_p)
		var pd = star.get_closest_point(p)
		star.connect_points(pd, id)
		nodes.erase(min_p)

	return star

## Connects roads and created filler wround the nodes
func build_nodes():
	for n in $Nodes.get_children():
		var l = []
		var p = path_all.get_closest_point(Vector3(n.position.x, n.position.y, 0))
		for c in path_all.get_point_connections(p):
			l.append(path_all.get_point_position(c))
			n.build_node(l)

func build_mains():
	var min_n = null
	var min_x = 0
	var max_n = null
	var max_x = 0
	for n in $Nodes.get_children():
		if n.position.x < min_x:
			min_n = n.position
			min_x = n.position.x
		if n.position.x > max_x:
			max_n = n.position
			max_x = n.position.x
	
	var min_i = path_all.get_available_point_id()
	var min_p = path_all.get_closest_point(Vector3(min_n.x, min_n.y, 0))
	path_all.add_point(min_i, Vector3(min_n.x * 1.5, min_n.y * 1.25, 0))
	path_all.connect_points(min_i, min_p)

	var max_i = path_all.get_available_point_id()
	var max_p = path_all.get_closest_point(Vector3(max_n.x, max_n.y, 0))
	path_all.add_point(max_i, Vector3(max_n.x * 1.5, max_n.y * 1.25, 0))
	path_all.connect_points(max_i, max_p)

	var id_path = path_all.get_id_path(min_i, max_i)

	var positions = []
	for p in id_path:
		positions.append(path_all.get_point_position(p))
	path_main = run_prims_algorithm(positions)

func build_grids():
	var grid = $Grid

	# Draw the main road sections
	for from in path_main.get_points():
		var from_position = path_main.get_point_position(from)
		for to in path_main.get_point_connections(from):
			var to_position = path_main.get_point_position(to)
			grid.draw_main_road(from_position, to_position)
			yield(get_tree().create_timer(0.01), 'timeout')
			
	# Draw the side road sections
	for from in path_all.get_points():
		var from_position = path_all.get_point_position(from)
		for to in path_all.get_point_connections(from):
			var to_position = path_all.get_point_position(to)
			grid.draw_side_road(from_position, to_position)
			yield(get_tree().create_timer(0.01), 'timeout')

	# Draw the town nodes and blocks
	for n in $Nodes.get_children():
		grid.draw_town_node(n.position, n.size, n.type)
