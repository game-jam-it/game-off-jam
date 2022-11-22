extends Control

var _scene = null

onready var enemy_list = get_node("%EnemyList")

onready var lore_box = get_node("%LoreGroup")
onready var relic_box = get_node("%RelicGroup")
onready var banish_box = get_node("%BanishGroup")

onready var lore_label = get_node("%LoreValue")
onready var relic_label = get_node("%RelicValue")
onready var banish_label = get_node("%BanishValue")

var enemy_box = preload("res://UserInterface/EventHud/prefabs/EnemyInfoBox.tscn")

func _ready():
	pass

func enable():
	visible = true

func disable():
	visible = false
	for box in enemy_list.get_children():
		box.queue_free()
	if _scene != null:
		_scene.disconnect("goals_updated", self, "_on_goals_updated")
		_scene = null

func initialize(coords):
	if visible:
		return
	visible = true
	print_debug(">>> Init Event Hud: %s" % coords)
	setup_event_data(coords)


func setup_event_data(coords):
	for box in enemy_list.get_children():
		box.queue_free()
	_scene = TheTown.get_events().get_scene(coords)
	if _scene == null:
		print_debug(">> %s: scene not found", name)
		return
	_scene.connect("goals_updated", self, "_on_goals_updated")
	for obj in _scene.queue().get_children():
		if obj is QueueObject:
			var ent = obj.entity()
			match ent.group:
				EntityObject.Group.Enemy:
					var box = enemy_box.instance()
					enemy_list.add_child(box)
					box.initialize(ent)
	var goals = _scene.goals()
	lore_box.visible = goals.lore.total > 0
	relic_box.visible = goals.relic.total > 0
	banish_box.visible = goals.banish.total > 0
	lore_label.text = "0/%s" % goals.lore.total
	relic_label.text = "0/%s" % goals.relic.total
	banish_label.text = "0/%s" % goals.banish.total
	

func _on_goals_updated(goals):
	lore_label.text = "%s/%s" % [goals.lore.done, goals.lore.total]
	relic_label.text = "%s/%s" % [goals.relic.done, goals.relic.total]
	banish_label.text = "%s/%s" % [goals.banish.done, goals.banish.total]

# TODO These updates should not happen with scene events

# func on_enemy_died(entity: EnemyEntity):
# 	if entity == null: 
# 		return
# 	_banish_cnt += 1
# 	_disconnect_entity(entity)
# 	banish_label.text = "%s/%s" % [_banish_cnt, _banish_total]

# func on_picked_up(entity: PickupEntity):
# 	_disconnect_entity(entity)
# 	if entity == null: 
# 		return
# 	_pickups_cnt += 1
# 	if entity.slot == PickupEntity.Slot.Relic: 
# 		_relic_cnt += 1
# 		relic_label.text = "%s/%s" % [_relic_cnt, _relic_total]

# func on_escape_pressed():
# 	print_debug("[%s] TODO Implement escape dialog" % name)
# 	TheTown.stop_active_event()

# func _disconnect_entity(entity):
# 	match entity.group:
# 		EntityObject.Group.Enemy:
# 			entity.disconnect("enemy_died", self, "on_enemy_died")
# 		EntityObject.Group.Pickup:
# 			entity.disconnect("picked_up", self, "on_picked_up")
