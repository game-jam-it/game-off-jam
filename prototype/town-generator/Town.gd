extends Node2D

var min_size = 3
var max_size = 9
var tile_size = 48
var node_count = 64
var nodes_culled = 0.2

var x_spread = 200
var y_spread = 20

var path = null
var is_ready = false

var NodeScene = preload("res://prototype/town-generator/TownNode.tscn")

func _ready():
	randomize()
	make_nodes()

func _draw():
	#for n in $Nodes.get_children():
	#	var r = Rect2(n.position - n.size, n.size * 2)
	#	if is_ready:
	#		draw_rect(r, Color(0, 1, 1), false)
	#	else:
	#		draw_rect(r, Color(1, 1, 0), false)
	if path:
		for p in path.get_points():
			var pp = path.get_point_position(p)
			#draw_circle(Vector2(pp.x, pp.y), 32.0, Color(1, 0, 0))
			for c in path.get_point_connections(p):
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1, 1, 0), 8, true)

func _input(event):
	if is_ready && event.is_action_pressed("ui_select"):
		for n in $Nodes.get_children():
			n.queue_free()
		path = null
		make_nodes()

func _process(_delta):
	update()

func make_nodes():
	is_ready = false
	for _i in range(node_count):
		var p = Vector2(
			rand_range(-x_spread, x_spread), 
			rand_range(-y_spread, y_spread)
		)
		var n = NodeScene.instance()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		n.make_node(p, Vector2(w, h) * tile_size)
		$Nodes.add_child(n)
	# Wait for the physics animation to end
	yield(get_tree().create_timer(0.8), 'timeout')

	var node_positions = []
	for n in $Nodes.get_children():
		if randf() < nodes_culled:
			n.queue_free()
		else:
			n.mode = RigidBody2D.MODE_STATIC
			node_positions.append(Vector3(n.position.x, n.position.y, 0))

		yield(get_tree().create_timer(0.01), 'timeout')
	path = run_prims_algorithm(node_positions)
	is_ready = true
	build_nodes()

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
		var p = path.get_closest_point(Vector3(n.position.x, n.position.y, 0))
		for c in path.get_point_connections(p):
			l.append(path.get_point_position(c))
			n.build_node(l)
