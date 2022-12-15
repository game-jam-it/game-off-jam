class_name ExpeditionMap
extends EventMap

# FixMe _static objects are copies and a hack,
# it was added to make the Townmap more filled.

var is_saved = false
var is_active = false

onready var _grid = $Grid
onready var _queue = $Queue
onready var _static = $Static
onready var _objects = $Objects
onready var _connects = $Connects

onready var _moon_light = $MoonLight

func queue():
	return self._queue

func goals():
	return self._goals

func _ready():
	self._init_goals()
	_type = Type.Expedition
	_objects.visible = false
	_moon_light.visible = false
	# TODO Only hide the actors leave some of the map up
	_queue.connect("queue_changed", self, "on_queue_changed")
	_queue.connect("active_changed", self, "on_active_changed")

"""
	Handle Event State
"""

func end_event():
	# TODO: Save State
	_queue.disable()
	self.is_active = false
	_objects.visible = false
	_moon_light.visible = false
	print("%s ending" % name)
	yield(get_tree(), "idle_frame")
	_static.visible = true
	self._save_map_state()

func start_event():
	_grid.clear()
	_queue.reset(_grid)
	_static.visible = false
	yield(get_tree(), "idle_frame")
	self._load_map_state()
	self._setup_map_objects()
	yield(get_tree(), "idle_frame")
	_queue.enable()
	self.is_active = true
	_objects.visible = true
	_moon_light.visible = true
	print("%s starting" % name)
	emit_signal("stats_updated", _goals)
	yield(get_tree(), "idle_frame")
	yield(run_event(), "completed")

func run_event():
	# Note: Clearing the Queue is critical
	# Yield on events is not cleared untill
	# the event is triggered, check children!
	yield(_queue.play_turn(), "completed")
	if is_active: yield(run_event(), "completed")

"""
	Handle Queue Updates
"""

func on_queue_changed(list):
	# TODO Update UI
	# for e in list:
	# 	print("List: %s (%s)" % [e.name(), e.initiative()])
	pass

func on_active_changed(active):
	# TODO Update UI
	# if active != null:
	# 	print("Active: %s (%s)" % [active.name(), active.initiative()])
	pass

"""
	Event Map state
"""

static func new_goals():
	return {
		"lore": {"done": 0, "total": 0,},
		"banish": {
			"done": 0, "total": 0,
			"boss": {"done": 0, "total": 0,},
			"drone": {"done": 0, "total": 0,},
		},
		"pickup": {
			"done": 0, "total": 0,
			"relic": {"done": 0, "total": 0,},
			"money": {"done": 0, "total": 0,},
			"weapon": {"done": 0, "total": 0,},
			"trinket": {"done": 0, "total": 0,},
			"consumable": {"done": 0, "total": 0,},
		},
		"challenge": {
			"done": 0, "total": 0,
			"hide": {"done": 0, "total": 0,},
			"escape": {"done": 0, "total": 0,},
		},
	}


func _init_goals():
	# TODO Has save file? else:
	self.is_saved = false
	_build_map_goals()

func _build_map_goals():
	self._goals = self.new_goals()
	for ent in self._objects.get_children():
		if ent is BaseEntity:
			match ent.group:
				BaseEntity.Group.Enemy:
					self._build_enemy_goals(ent)
				BaseEntity.Group.Lore:
					self._build_lore_goals()
				BaseEntity.Group.Pickup:
					self._build_pickup_goals(ent)

func _build_enemy_goals(ent):
	_goals.banish.total += 1
	match ent.slot:
		EnemyActor.Slot.Boss: _goals.banish.boss.total += 1
		EnemyActor.Slot.Drone: _goals.banish.drone.total += 1

func _build_lore_goals():
	_goals.lore.total += 1

func _build_pickup_goals(ent):
	_goals.pickup.total += 1
	match ent.slot:
		ItemEntity.Slot.Relic: _goals.pickup.relic.total += 1
		ItemEntity.Slot.Money: _goals.pickup.money.total += 1
		ItemEntity.Slot.Weapon: _goals.pickup.weapon.total += 1
		ItemEntity.Slot.Trinket: _goals.pickup.trinket.total += 1
		ItemEntity.Slot.Consumable: _goals.pickup.consumable.total += 1


"""
	Event Map state
"""

func _load_map_state():
	self.is_saved = false
	# TODO: If Savefile: 
	# is_saved = true
	# - Load State

func _save_map_state():
	# TODO: Save to file 
	# TODO Save data to file
	for obj in self._objects.get_children():
		if obj is BaseEntity:
			match obj.group:
				BaseEntity.Group.Enemy:
					obj.disconnect("enemy_died", self, "_on_enemy_died")
				BaseEntity.Group.Player:
					continue
				BaseEntity.Group.Lore:
					continue
				BaseEntity.Group.Pickup:
					obj.disconnect("picked_up", self, "_on_picked_up")


func _setup_map_objects():
	# TODO Loop and sort objects
	# - Set map goals (see hud)
	for obj in self._objects.get_children():
		if obj is GridObject:
			self._grid.add_object(obj)
		elif obj is BaseEntity:
			_setup_entity(obj)

func _setup_entity(ent):
	ent.set_grid(self._grid)
	match ent.group:
		BaseEntity.Group.Enemy:
			self._setup_enemy_entity(ent)
		BaseEntity.Group.Player:
			self._setup_player_entity(ent)
		BaseEntity.Group.Lore:
			self._setup_lore_entity(ent)
		BaseEntity.Group.Pickup:
			self._setup_pickup_entity(ent)
		BaseEntity.Group.Challenge:
			self._setup_challenge_entity(ent)

func _setup_enemy_entity(ent):
	_queue.add_entity(ent)
	ent.connect("enemy_died", self, "_on_enemy_died")

func _setup_player_entity(ent):
	_queue.add_entity(ent)
	# TODO Link up player
	# Is this stil valid or?
	# Did we switch to one actor

func _setup_lore_entity(ent):
	# TODO Link up lore
	pass

func _setup_pickup_entity(ent):		
	ent.connect("picked_up", self, "_on_picked_up")

func _setup_challenge_entity(ent):
	# TODO Link up challenge
	pass


"""
	Entity Events
"""

func _on_enemy_died(ent: EnemyActor):
	ent.disconnect("enemy_died", self, "_on_enemy_died")
	_goals.banish.done += 1
	match ent.slot:
		EnemyActor.Slot.Boss: _goals.banish.boss.done += 1
		EnemyActor.Slot.Drone: _goals.banish.drone.done += 1
	emit_signal("stats_updated", _goals)


func _on_picked_up(ent: ItemEntity):
	ent.disconnect("picked_up", self, "_on_picked_up")
	_goals.pickup.done += 1
	match ent.slot:
		ItemEntity.Slot.Relic: _goals.pickup.relic.done += 1
		ItemEntity.Slot.Money: _goals.pickup.money.done += 1
		ItemEntity.Slot.Weapon: _goals.pickup.weapon.done += 1
		ItemEntity.Slot.Trinket: _goals.pickup.trinket.done += 1
		ItemEntity.Slot.Consumable: _goals.pickup.consumable.done += 1
	emit_signal("stats_updated", _goals)
