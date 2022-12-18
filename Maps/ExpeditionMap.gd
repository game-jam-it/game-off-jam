class_name ExpeditionMap
extends EventMap

# FixMe _static objects are copies and a hack,
# it was added to make the Townmap more filled.

const Ok: String = ""


signal picked_up(item)

signal dare_ended(event)
signal dare_started(event)

signal lore_ended(event)
signal lore_started(event)


onready var _grid = $Grid
onready var _queue = $Queue
onready var _objects = $Objects


func get_grid() -> EventGrid:
	return _grid

func get_queue() -> ActorQueue:
	return _queue



func _ready():
	_type = EventMap.Type.Expedition


func end_event():
	leave_map()

func start_event():
	enter_map()


func enter_map(team_queue: bool = true):
	for actor in _queue.get_actors():
		actor.enable()
	_queue.run(_grid, team_queue)

func leave_map():
	_queue.stop()
	for actor in _queue.get_actors():
		actor.disable()

func pause_map():
	_queue.pause()

func resume_map():
	_queue.resume()



func initialize():
	_grid.clear()
	_queue.clear()
	for object in _objects.get_children():
		if object is GridObject: _grid.add_object(object)
		elif object is BaseEntity: _initialize_entity(object)
		else: _object_error("initialize: unknown object", object)

func _initialize_entity(entity: BaseEntity):
	entity.set_grid(_grid)
	match entity.group:
		BaseEntity.Group.None:
			_entity_error("initialize: entity is none", entity)
		BaseEntity.Group.Item:
			var err = _initialize_item(entity)
			if not err.empty(): _entity_error(err, entity)
		BaseEntity.Group.Dare:
			var err = _initialize_dare_event(entity)
			if not err.empty(): _entity_error(err, entity)
		BaseEntity.Group.Lore:
			var err = _initialize_lore_event(entity)
			if not err.empty(): _entity_error(err, entity)
		BaseEntity.Group.Enemy:
			var err = _initialize_enemy_actor(entity)
			if not err.empty(): _entity_error(err, entity)
		BaseEntity.Group.Player:
			var err = _initialize_player_actor(entity)
			if not err.empty(): _entity_error(err, entity)


func _initialize_item(entity: BaseItem) -> String:
	if entity == null:
		return "initialize: item entity is null"
	entity.connect("picked_up", self, "_on_picked_up")
	_goals.pickup.total += 1
	match entity.slot:
		BaseItem.Slot.Relic:
			_goals.pickup.relic.total += 1
		BaseItem.Slot.Money: 
			_goals.pickup.money.total += 1
		BaseItem.Slot.Weapon: 
			_goals.pickup.weapon.total += 1
		BaseItem.Slot.Trinket: 
			_goals.pickup.trinket.total += 1
		BaseItem.Slot.Consumable: 
			_goals.pickup.consumable.total += 1
	return Ok

func _on_picked_up(item: BaseItem):
	_goals.pickup.done += 1
	match item.slot:
		BaseItem.Slot.Relic:
			_goals.pickup.relic.done += 1
		BaseItem.Slot.Money: 
			_goals.pickup.money.done += 1
		BaseItem.Slot.Weapon: 
			_goals.pickup.weapon.done += 1
		BaseItem.Slot.Trinket: 
			_goals.pickup.trinket.done += 1
		BaseItem.Slot.Consumable: 
			_goals.pickup.consumable.done += 1
	emit_signal("goals_updated", _goals)
	emit_signal("picked_up", item)


func _initialize_dare_event(event: DareEvent) -> String:
	if event == null:
		return "initialize: dare event is null"
	event.connect("started", self, "_on_dare_started")
	event.connect("ended", self, "_on_dare_ended")
	_goals.event.dare.total += 1
	return Ok

func _on_dare_ended(event: DareEvent):
	event.disconnect("started", self, "_on_dare_started")
	event.disconnect("ended", self, "_on_dare_ended")
	_goals.event.dare.done += 1
	emit_signal("goals_updated", _goals)
	emit_signal("dare_ended", event)
	# TODO: Trigger dare ended

func _on_dare_started(event: DareEvent):
	emit_signal("dare_started", event)
	# TODO: Trigger dare started


func _initialize_lore_event(event: LoreEvent) -> String:
	if event == null:
		return "initialize: lore event is null"
	event.connect("started", self, "_on_lore_started")
	event.connect("ended", self, "_on_lore_ended")
	_goals.event.lore.total += 1
	return Ok

func _on_lore_ended(event: LoreEvent):
	event.disconnect("started", self, "_on_lore_started")
	event.disconnect("ended", self, "_on_lore_ended")
	_goals.event.lore.done += 1
	emit_signal("goals_updated", _goals)
	emit_signal("lore_ended", event)
	# TODO: Trigger lore ended

func _on_lore_started(event: LoreEvent):
	emit_signal("lore_started", event)
	# TODO: Trigger lore started


func _initialize_enemy_actor(actor: EnemyActor) -> String:
	if actor == null:
		return "initialize: enemy actor is null"
	actor.connect("enemy_died", self, "_on_enemy_died")
	_queue.add_actor(actor)
	_goals.banish.total += 1
	match actor.slot:
		EnemyActor.Slot.Boss:
			_goals.banish.boss.total += 1
		EnemyActor.Slot.Drone:
			_goals.banish.drone.total += 1
	return Ok

func _on_enemy_died(actor: EnemyActor):
	actor.disconnect("enemy_died", self, "_on_enemy_died")
	_queue.remove_actor(actor)
	_goals.banish.done += 1
	match actor.slot:
		EnemyActor.Slot.Boss:
			_goals.banish.boss.done += 1
		EnemyActor.Slot.Drone:
			_goals.banish.drone.done += 1
	emit_signal("goals_updated", _goals)
	# TODO: Trigger enemy died


func _initialize_player_actor(actor: PlayerActor) -> String:
	if actor == null:
		return "initialize: player actor is null"
	actor.connect("player_died", self, "_on_player_died")
	_queue.add_actor(actor)
	return Ok

func _on_player_died(actor: PlayerActor):
	actor.disconnect("player_died", self, "_on_player_died")
	_queue.remove_actor(actor)
	# TODO: Trigger player died



func _object_error(message: String, object: Object):
	push_error("[Error] %s: %s: %s" % [name, message, object.name])
	object.queue_free()

func _entity_error(message: String, entity: BaseEntity):
	push_error("[Error] %s: %s: %s - %s" % [name, message, entity.name, entity.group])
	entity.queue_free()