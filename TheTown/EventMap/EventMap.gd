class_name EventMap
extends Node2D

var _goals = {}

var is_saved = false
var is_active = false

signal goals_updated(goals)

onready var _grid = $Grid
onready var _queue = $Queue
onready var _objects = $Objects
onready var _connects = $Connects

export(String) var map_title = "Unknown"
export(String, MULTILINE) var map_summary = "An unknown map"

func queue():
	return self._queue

func goals():
	return self._goals

func _ready():
	_queue.connect("queue_changed", self, "on_queue_changed")
	_queue.connect("active_changed", self, "on_active_changed")

func _reset_goals():
	self._goals = {
		"lore": {"done": 0, "total": 0,},
		"relic": {"done": 0, "total": 0,},
		"banish": {"done": 0, "total": 0,},
		"pickups": {"done": 0, "total": 0,},
		"challenge": {"done": 0, "total": 0,},
	}

"""
	Handle Event State
"""

func end_event():
	# TODO: Save State
	_queue.disable()
	self.is_active = false
	print("%s ending" % name)
	yield(get_tree(), "idle_frame")
	self._save_map_state()

func start_event():
	_queue.reset(_grid)
	yield(get_tree(), "idle_frame")
	self._load_map_state()
	self._setup_map_objects()
	yield(get_tree(), "idle_frame")
	_queue.enable()
	self.is_active = true
	print("%s starting" % name)
	yield(get_tree(), "idle_frame")
	yield(run_event(), "completed")

func run_event():
	# Note: Clearing the Queue is critical
	# Yield on events is not be cleared untill
	# the event is triggered, check all children!
	yield(_queue.play_turn(), "completed")
	if is_active: yield(run_event(), "completed")

"""
	Handle Queue Updates
"""

func on_queue_changed(list):
		# TODO Update UI
	for e in list:
		print("List: %s (%s)" % [e.name(), e.initiative()])

func on_active_changed(active):
	if active != null:
		print("Active: %s (%s)" % [active.name(), active.initiative()])

"""
	Event Map state
"""

func _load_map_state():
	self.is_saved = false
	self._reset_goals()
	# TODO: If Savefile: 
	# is_saved = true
	# - Load State

func _save_map_state():
	# TODO: Save to file 
	# TODO Save data to file
	for obj in self._objects.get_children():
		if obj is EntityObject:
			match obj.group:
				EntityObject.Group.Enemy:
					obj.disconnect("enemy_died", self, "_on_enemy_died")
				EntityObject.Group.Player:
					continue
				EntityObject.Group.Lore:
					continue
				EntityObject.Group.Pickup:
					obj.disconnect("picked_up", self, "_on_picked_up")

func _setup_map_objects():
	# TODO Loop and sort objects
	# - Set map goals (see hud)
	for obj in self._objects.get_children():
		if obj is GridObject:
			self._grid.add_object(obj)
		elif obj is EntityObject:
			_setup_entity_object(obj)

func _setup_entity_object(ent):
	match ent.group:
		EntityObject.Group.Enemy:
			self._setup_enemy_entity(ent)
		EntityObject.Group.Player:
			self._setup_player_entity(ent)
		EntityObject.Group.Lore:
			self._setup_lore_entity(ent)
		EntityObject.Group.Pickup:
			self._setup_pickup_entity(ent)
		EntityObject.Group.Challenge:
			self._setup_challenge_entity(ent)

func _setup_enemy_entity(ent):
	if !self.is_saved: 
		_goals.banish.total += 1
	_queue.add_entity(ent)
	ent.connect("enemy_died", self, "_on_enemy_died")

func _setup_player_entity(ent):
	_queue.add_entity(ent)
	# TODO Link up player

func _setup_lore_entity(ent):
	if !self.is_saved: 
		_goals.lore.total += 1
	# TODO Link up lore

func _setup_pickup_entity(ent):
	if !self.is_saved: 
		_goals.pickups.total += 1
		if ent.slot == PickupEntity.Slot.Relic:
			_goals.relic.total += 1
	ent.connect("picked_up", self, "_on_picked_up")

func _setup_challenge_entity(ent):
	if !self.is_saved: 
		_goals.challenge.total += 1
	# TODO Link up challenge

"""
	Entity Events
"""

func _on_enemy_died(ent: EnemyEntity):
	ent.disconnect("enemy_died", self, "_on_enemy_died")
	_goals.banish.done += 1
	emit_signal("goals_updated", _goals)


func _on_picked_up(ent: PickupEntity):
	ent.disconnect("picked_up", self, "_on_picked_up")
	if ent.slot == PickupEntity.Slot.Relic:
		_goals.relic.done += 1
	_goals.pickups.done += 1
	emit_signal("goals_updated", _goals)
