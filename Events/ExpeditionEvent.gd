class_name ExpeditionEvent
extends EventMap

var is_saved = false
var is_active = false

onready var _grid = $Grid
onready var _queue = $Queue
onready var _objects = $Objects
onready var _connects = $Connects

func queue():
	return self._queue

func goals():
	return self._goals

func _ready():
	self._setup()

func _setup():
	self._init_goals()
	_type = Type.Expedition
	_objects.visible = false
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
	print("%s ending" % name)
	yield(get_tree(), "idle_frame")
	self._save_map_state()

func start_event():
	_grid.clear()
	_queue.reset(_grid)
	yield(get_tree(), "idle_frame")
	self._load_map_state()
	self._setup_map_objects()
	yield(get_tree(), "idle_frame")
	_queue.enable()
	self.is_active = true
	_objects.visible = true
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
	for e in list:
		print("List: %s (%s)" % [e.name(), e.initiative()])

func on_active_changed(active):
	if active != null:
		print("Active: %s (%s)" % [active.name(), active.initiative()])

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
		if ent is EntityObject:
			match ent.group:
				EntityObject.Group.Enemy:
					self._build_enemy_goals(ent)
				EntityObject.Group.Lore:
					self._build_lore_goals()
				EntityObject.Group.Pickup:
					self._build_pickup_goals(ent)

func _build_enemy_goals(ent):
	_goals.banish.total += 1
	match ent.slot:
		EnemyEntity.Slot.Boss: _goals.banish.boss.total += 1
		EnemyEntity.Slot.Drone: _goals.banish.drone.total += 1

func _build_lore_goals():
	_goals.lore.total += 1

func _build_pickup_goals(ent):
	_goals.pickup.total += 1
	match ent.slot:
		PickupEntity.Slot.Relic: _goals.pickup.relic.total += 1
		PickupEntity.Slot.Money: _goals.pickup.money.total += 1
		PickupEntity.Slot.Weapon: _goals.pickup.weapon.total += 1
		PickupEntity.Slot.Trinket: _goals.pickup.trinket.total += 1
		PickupEntity.Slot.Consumable: _goals.pickup.consumable.total += 1


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
	_queue.add_entity(ent)
	ent.connect("enemy_died", self, "_on_enemy_died")

func _setup_player_entity(ent):
	_queue.add_entity(ent)
	# TODO Link up player

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

func _on_enemy_died(ent: EnemyEntity):
	ent.disconnect("enemy_died", self, "_on_enemy_died")
	_goals.banish.done += 1
	match ent.slot:
		EnemyEntity.Slot.Boss: _goals.banish.boss.done += 1
		EnemyEntity.Slot.Drone: _goals.banish.drone.done += 1
	emit_signal("stats_updated", _goals)


func _on_picked_up(ent: PickupEntity):
	ent.disconnect("picked_up", self, "_on_picked_up")
	_goals.pickup.done += 1
	match ent.slot:
		PickupEntity.Slot.Relic: _goals.pickup.relic.done += 1
		PickupEntity.Slot.Money: _goals.pickup.money.done += 1
		PickupEntity.Slot.Weapon: _goals.pickup.weapon.done += 1
		PickupEntity.Slot.Trinket: _goals.pickup.trinket.done += 1
		PickupEntity.Slot.Consumable: _goals.pickup.consumable.done += 1
	emit_signal("stats_updated", _goals)
