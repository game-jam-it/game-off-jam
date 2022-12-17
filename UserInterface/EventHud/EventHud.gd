extends Control

var _scene = null

onready var enemy_list = get_node("%EnemyList")

onready var action_box = get_node("%ActionBox")
onready var thread_box = get_node("%ThreatBox")

onready var leave_button = get_node("%LeaveButton")
onready var escape_button = get_node("%EscapeButton")

onready var lore_box = get_node("%LoreGroup")
onready var relic_box = get_node("%RelicGroup")
onready var banish_box = get_node("%BanishGroup")

onready var lore_label = get_node("%LoreValue")
onready var relic_label = get_node("%RelicValue")
onready var banish_label = get_node("%BanishValue")

var enemy_box = preload("res://UserInterface/EventHud/prefabs/EnemyInfoBox.tscn")

func _ready():
	leave_button.connect("pressed", self, "_on_leave_pressed")
	escape_button.connect("pressed", self, "_on_escape_pressed")

func enable():
	visible = true
	action_box.visible = false
	thread_box.visible = true
	leave_button.visible = false
	escape_button.visible = true

func disable():
	visible = false
	for box in enemy_list.get_children():
		box.queue_free()
	if _scene != null:
		for obj in _scene.queue().get_children():
			if obj is QueueObject:
				var ent = obj.entity()
				if ent.group == BaseEntity.Group.Enemy && ent.hidden: 
					ent.disconnect("unhide_entity", self, "_on_unhide_enemy")
		if _scene is ExpeditionMap:
			_scene.queue().disconnect("queue_changed", self, "_on_queue_changed")
		_scene.disconnect("map_conpleted", self, "_on_map_conpleted")
		_scene.disconnect("goals_updated", self, "_on_goals_updated")
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
	_scene.connect("map_conpleted", self, "_on_map_conpleted")
	_scene.connect("goals_updated", self, "_on_goals_updated")
	if _scene is ExpeditionMap:
		_scene.queue().connect("queue_changed", self, "_on_queue_changed")
	var list = _scene.queue().get_children()
	# FixMe See: call order yields, it pushes it back but is bug prone
	if list == null: print_debug("[WARN] %s: entity list is null" % name)
	if list.size() == 0: print_debug("[WARN] %s: entity list empty" % name)
	for obj in list:
		if obj is QueueObject:
			var ent = obj.entity()
			match ent.group:
				BaseEntity.Group.Enemy:
					if !ent.hidden: self._create_box(ent)
					else: ent.connect("unhide_entity", self, "_on_unhide_enemy")

	var goals = _scene.goals()
	lore_box.visible = true
	# TODO Setup goals again, hacked up
	#lore_box.visible = goals.event.lore.total > 0
	relic_box.visible = goals.pickup.relic.total > 0
	banish_box.visible = goals.banish.total > 0
	lore_label.text = "0/1"
	#lore_label.text = "0/%s" % goals.event.lore.total
	relic_label.text = "0/%s" % goals.pickup.relic.total
	banish_label.text = "0/%s" % goals.banish.total

func _create_box(entity):
	var box = enemy_box.instance()
	enemy_list.add_child(box)
	box.initialize(entity)

func _on_leave_pressed():
	if !TheTown.is_paused() && visible: 
		TheTown.stop_active_event()

func _on_escape_pressed():
	print("[%s] TODO Escape dialog" % name)
	if !TheTown.is_paused() && visible: 
		TheTown.stop_active_event()

func _on_map_conpleted(_event):
	action_box.visible = true
	thread_box.visible = false

func _on_queue_changed(_list):
	if enemy_list.get_child_count() == 0: 
		leave_button.visible = true
		escape_button.visible = false
	else:
		leave_button.visible = false
		escape_button.visible = true

func _on_goals_updated(goals):
	lore_label.text = "%s/%s" % [goals.banish.boss.done, goals.banish.boss.total]
	#lore_label.text = "%s/%s" % [goals.event.lore.done, goals.event.lore.total]
	relic_label.text = "%s/%s" % [goals.pickup.relic.done, goals.pickup.relic.total]
	banish_label.text = "%s/%s" % [goals.banish.done, goals.banish.total]

func _on_unhide_enemy(entity):
	entity.disconnect("unhide_entity", self, "_on_unhide_enemy")
	leave_button.visible = false
	escape_button.visible = true
	self._create_box(entity)
