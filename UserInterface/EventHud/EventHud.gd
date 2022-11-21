extends Control

# TODO: Move counts and totals into the event state 
# it is required to save and restore the global state

var _lore_cnt = 0
var _lore_total = 0

var _relic_cnt = 0
var _relic_total = 0

var _banish_cnt = 0
var _banish_total = 0

var _pickups_cnt = 0
var _pickups_total = 0

var _challenges_cnt = 0
var _challenges_total = 0

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

	print_debug("[%s] TODO setup entity links" % name)
	for entity in scene.queue.get_children():
		match entity.group:
			EntityObject.Group.Enemy:
				entity.connect("enemy_died", self, "on_enemy_died")
				var box = enemy_box.instance()
				enemy_list.add_child(box)
				box.initialize(entity)
				_banish_total += 1
			EntityObject.Group.Player:
				continue
			EntityObject.Group.Lore:
				# TODO Lore entity links
				_lore_total += 1
			EntityObject.Group.Pickup:
				entity.connect("picked_up", self, "on_picked_up")
				_pickups_total += 1
				if entity.slot == PickupEntity.Slot.Relic:
					_relic_total += 1
			EntityObject.Group.Challenge:
				# TODO Challenge entity links
				_challenges_total += 1

	lore_box.visible = _lore_total > 0
	relic_box.visible = _relic_total > 0
	banish_box.visible = _banish_total > 0

	lore_label.text = "0/%s" % _lore_total
	relic_label.text = "0/%s" % _relic_total
	banish_label.text = "0/%s" % _banish_total


func on_enemy_died(entity: EnemyEntity):
	if entity != null: _banish_cnt += 1
	banish_label.text = "%s/%s" % [_banish_cnt, _banish_total]

func on_picked_up(entity: PickupEntity):
	if entity != null: 
		return
	_pickups_cnt += 1
	if entity.slot == PickupEntity.Slot.Relic: _relic_cnt
	relic_label.text = "%s/%s" % [_relic_cnt, _relic_total]
