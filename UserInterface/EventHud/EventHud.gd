extends Control

onready var enemy_list = get_node("%EnemyList")

var enemy_box = preload("res://UserInterface/EventHud/prefabs/EnemyInfoBox.tscn")

func _ready():
	pass


func enable():
	visible = true

func disable():
	visible = false

func initialize(coords):
	if visible:
		return
	visible = true
	setup_event_data(coords)


func setup_event_data(coords):
	for box in enemy_list.get_children():
		box.queue_free()
	var scene = TheTown.get_events().get_scene(coords)
	if scene == null:
		print_debug(">> %s: scene not found", name)
		return
	for entity in scene.queue.get_children():
		if entity.group != Entity.Group.Enemy:
			continue
		var box = enemy_box.instance();
		enemy_list.add_child(box)
		box.initialize(entity)
	# from the active scene get the queue
	# for enemies in the queu make box
