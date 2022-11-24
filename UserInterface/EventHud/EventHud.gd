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
					if !ent.hidden: self._create_box(ent)
					else: ent.connect("enemy_unhide", self, "_on_enemy_unhide")

	var goals = _scene.goals()
	lore_box.visible = goals.lore.total > 0
	relic_box.visible = goals.relic.total > 0
	banish_box.visible = goals.banish.total > 0
	lore_label.text = "0/%s" % goals.lore.total
	relic_label.text = "0/%s" % goals.relic.total
	banish_label.text = "0/%s" % goals.banish.total

func _create_box(entity):
	var box = enemy_box.instance()
	enemy_list.add_child(box)
	box.initialize(entity)

func _on_goals_updated(goals):
	lore_label.text = "%s/%s" % [goals.lore.done, goals.lore.total]
	relic_label.text = "%s/%s" % [goals.relic.done, goals.relic.total]
	banish_label.text = "%s/%s" % [goals.banish.done, goals.banish.total]

func _on_enemy_unhide(entity):
	entity.disconnect("enemy_unhide", self, "_on_enemy_unhide")
	self._create_box(entity)
