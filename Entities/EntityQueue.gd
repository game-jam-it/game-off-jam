class_name EntityQueue
extends Node2D

signal queue_changed(list)
signal active_changed(active)

onready var active: Entity

func initialize():
	_sort_entities()
	if get_child_count() > 0: 
		active = get_child(0)
		emit_signal('active_changed', active)

"""
	Handle queued turns
"""

func skip_turn():
	_next_entity()

func play_turn():
	var target = yield(active.input.choose_target(), "completed")
	if target == null:
		_next_entity()
		return
	var action = yield(active.input.choose_action(), "completed")
	if action == null:
		_next_entity()
		return
	yield(action.execute(target), "completed")
	_next_entity()

func _next_entity():
	var count = get_child_count()
	if count > 1: 
		var index = active.get_index()
		active = get_child((index+1) % count)
		emit_signal('active_changed', active)

func _sort_entities():
	var list = get_children()
	list.sort_custom(self, 'sort_queue')
	for entity in list: entity.raise()
	emit_signal('queue_changed', get_children())

static func sort_queue(a: Entity, b: Entity) -> bool:
	return a.initiative < b.initiative
