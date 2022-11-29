class_name EntityQueue
extends Node2D

var _grid: EventGrid
var _active: QueueObject

signal queue_changed(list)
signal active_changed(active)

var QueuePrefab = preload("res://Entities/QueueObject.tscn")

func reset(grid: EventGrid):
	visible = false
	self._grid = grid
	for obj in get_children():
		obj.queue_free()

func disable():
	visible = false
	for obj in get_children():
		obj.disable()

func enable():
	visible = true
	_sort_entities()
	for obj in get_children():
		obj.enable()
	if get_child_count() > 0: 
		_active = get_child(0)
		emit_signal('active_changed', _active)

func add_entity(entity: EntityActor):
	if entity != null:
		var obj = QueuePrefab.instance()
		obj.initialize(self, entity)
		self.add_child(obj)
		return
	print_debug("[%s] CRIT: Queued a null entity" % name)


"""
	Handle queued turns
"""

func skip_turn():
	# Note: Do we want to exit?
	yield(get_tree(), "idle_frame")
	return _next_entity()

func play_turn():
	if _active == null:
		return skip_turn()
	if _active.is_free():
		return skip_turn()
	_active.start_turn()
	var target = yield(_active.choose_target(), "completed")
	if target == null:
		_active.end_turn()
		return _next_entity()
	var action = yield(_active.choose_action(), "completed")
	if action == null:
		_active.end_turn()
		return _next_entity()
	yield(action.execute(), "completed")
	_active.end_turn()
	return _next_entity()

func _next_entity():
	var count = get_child_count()
	if count > 1: 
		var index = _active.get_index()
		if _active.is_free(): _active.clear()
		_active = get_child((index+1) % count)
		emit_signal('active_changed', _active)

"""
	Handle queued setup
"""

func _sort_entities():
	var list = get_children()
	list.sort_custom(self, 'sort_queue')
	for obj in list: obj.raise()
	emit_signal('queue_changed', get_children())

static func sort_queue(a, b) -> bool:
	return a.initiative() < b.initiative()
