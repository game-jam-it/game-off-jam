class_name QueueObject
extends Node2D

var _queue = null
var _entity = null

func _ready():
	connect("tree_exiting", self, "_on_tree_exiting")

func queue():
	return self._queue

func entity():
	return self._entity

func initialize(queue, entity):
	self._entity = entity
	self._queue = queue

func clear():
	self._entity.queue_free()
	self.queue_free()

func _on_tree_exiting():
	disconnect("tree_exiting", self, "_on_tree_exiting")
	self._entity = null
	self._queue = null


func name():
	return self._entity.name

func initiative():
	return self._entity.initiative

func disable():
	self._entity.disable()

func enable():
	self._entity.enable()

func is_free():
	return self._entity.is_free()

func end_turn():
	self._entity.end_turn()

func start_turn():
	self._entity.start_turn()

func choose_target():
	return self._entity.input.choose_target()

func choose_action():
	return self._entity.input.choose_action()