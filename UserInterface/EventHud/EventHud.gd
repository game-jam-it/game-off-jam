extends Control

var _scene = null

onready var enemy_list = get_node("%EnemyList")
onready var escape_button = get_node("%EscapeButton")

onready var lore_box = get_node("%LoreGroup")
onready var relic_box = get_node("%RelicGroup")
onready var banish_box = get_node("%BanishGroup")

onready var lore_label = get_node("%LoreValue")
onready var relic_label = get_node("%RelicValue")
onready var banish_label = get_node("%BanishValue")

var enemy_box = preload("res://UserInterface/EventHud/prefabs/EnemyInfoBox.tscn")

func _ready():
	escape_button.connect("pressed", self, "_on_escape_pressed")

func enable():
	visible = true

func disable():
	visible = false
	for box in enemy_list.get_children():
		box.queue_free()
	if _scene != null:
		for obj in _scene.queue().get_children():
			if obj is QueueObject:
				var ent = obj.entity()
				if ent.group == EntityObject.Group.Enemy && ent.hidden: 
					ent.disconnect("enemy_unhide", self, "_on_enemy_unhide")
		_scene.disconnect("stats_updated", self, "_on_stats_updated")
		_scene = null

func initialize(coords):
	if visible:
		print_debug("%s [WARN] initialize blocked" % name)
		return
	visible = true
	setup_event_data(coords)


func setup_event_data(coords):
	for box in enemy_list.get_children():
		box.queue_free()
	_scene = TheTown.get_events().get_scene(coords)
	if _scene == null:
		print_debug(">> %s: scene not found", name)
		return
	_scene.connect("stats_updated", self, "_on_stats_updated")
	var list = _scene.queue().get_children()
	# FixMe See: call order yields, it pushes it back but is bug prone
	if list == null: print_debug("[WARN] %s: entity list is null" % name)
	if list.size() == 0: print_debug("[WARN] %s: entity list empty" % name)
	for obj in list:
		if obj is QueueObject:
			var ent = obj.entity()
			match ent.group:
				EntityObject.Group.Enemy:
					if !ent.hidden: self._create_box(ent)
					else: ent.connect("enemy_unhide", self, "_on_enemy_unhide")

	var goals = _scene.goals()
	lore_box.visible = goals.lore.total > 0
	relic_box.visible = goals.pickup.relic.total > 0
	banish_box.visible = goals.banish.total > 0
	lore_label.text = "0/%s" % goals.lore.total
	relic_label.text = "0/%s" % goals.pickup.relic.total
	banish_label.text = "0/%s" % goals.banish.total

func _create_box(entity):
	var box = enemy_box.instance()
	enemy_list.add_child(box)
	box.initialize(entity)

func _on_escape_pressed():
	if !TheTown.is_paused() && visible: 
		TheTown.stop_active_event()

func _on_stats_updated(stats):
	lore_label.text = "%s/%s" % [stats.lore.done, stats.lore.total]
	relic_label.text = "%s/%s" % [stats.pickup.relic.done, stats.pickup.relic.total]
	banish_label.text = "%s/%s" % [stats.banish.done, stats.banish.total]

func _on_enemy_unhide(entity):
	entity.disconnect("enemy_unhide", self, "_on_enemy_unhide")
	self._create_box(entity)
