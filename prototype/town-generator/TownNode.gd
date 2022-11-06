class_name TownNode
extends RigidBody2D

var size: Vector2
var type: int

var links = 0
var linked = 0

const LINK_UP     = 1
const LINK_DOWN   = 1 << 1
const LINK_LEFT   = 1 << 2
const LINK_RIGHT  = 1 << 3

func _process(_delta):
	update()

func _draw():
	var p = $CollisionShape2D.position
	var r = Rect2(p - size, size * 2.0)
	if type == 1: 
		draw_rect(r, Color(0, 0.90, 0.90), false)
	elif type == 2: 
		draw_rect(r, Color(0, 0.50, 0.50), false)
	elif type == 3: 
		draw_rect(r, Color(0, 0.10, 0.10), false)
	else:
		draw_rect(r, Color(0.05, 0.05, 0.05), false)

	# if 0 != (linked & LINK_UP):
	# 	draw_link(Vector2(p.x, p.y - 64))
	# if 0 != (linked & LINK_DOWN):
	# 	draw_link(Vector2(p.x, p.y + 64))
	# if 0 != (linked & LINK_LEFT):
	# 	draw_link(Vector2(p.x - 64, p.y))
	# if 0 != (linked & LINK_RIGHT):
	# 	draw_link(Vector2(p.x + 64, p.y))

func make_node(_pos, _size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.70
	s.extents = size
	$CollisionShape2D.shape = s

func build_node(link_list):
	for link in link_list:
		mask_link(Vector2(link.x, link.y))

func draw_link(p):
	draw_circle(p, 32.0, Color(0.75, 0, 0.75))

func mask_link(link):
	var direction = link - position
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			linked = linked | LINK_RIGHT
		else:
			linked = linked | LINK_LEFT
	else:
		if direction.y > 0:
			linked = linked | LINK_DOWN
		else:
			linked = linked | LINK_UP
	pass
