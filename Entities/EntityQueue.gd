class_name EntityQueue
extends Node2D

signal queue_changed

onready var current: Entity

func initialize():
	var entities = get_children()
	entities.sort_custom(self, 'sort_queue')
	current = get_child(0)
	emit_signal('queue_changed', entities, current)

func sort_queue(a: Entity, b: Entity) -> bool:
	return a.initiative > b.initiative

"""
	Handle queued turns
"""

func skip_turn():
	_next_entity()

func play_turn():
	var target = yield(current.input.choose_target(), "completed")
	if target != null:
		_next_entity()
		return
	var action = yield(current.input.choose_action(), "completed")
	if action != null:
		_next_entity()
		return
	yield(action.execute(target), "completed")
	_next_entity()

func _next_entity():
	current = get_child((current.get_index() + 1) % get_child_count())
	emit_signal('queue_changed', get_children(), current)
