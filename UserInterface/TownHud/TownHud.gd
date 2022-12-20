extends Control

# TODO: Setup and link global objectives

onready var maps_label = get_node("%MapsValue")
onready var lore_label = get_node("%LoreValue")
onready var boss_label = get_node("%BossValue")

onready var map_list = get_node("%MapList")
onready var expedition_popup = $ExpeditionDialog
onready var event_coords_label = get_node("%EventCoordsLabel")

var map_box = preload("res://UserInterface/TownHud/prefabs/MapInfoBox.tscn")

func _ready():
	TheTown.connect("event_clear", self, "on_event_clear")
	TheTown.connect("event_focused", self, "on_event_focused")
	TheTown.connect("event_selected", self, "on_event_selected")
	
	var events = TheTown.get_events()
	events.connect("game_goals_updated", self, "_on_game_goals_updated")

	expedition_popup.connect("start_expedition", self, "on_start_expedition")
	expedition_popup.connect("cancel_expedition", self, "on_cancel_expedition")

func enable():
	visible = true

func disable():
	visible = false

func initialize():
	if visible:
		print_debug("%s [WARN] initialize blocked" % name)
		return
	visible = true
	setup_event_list()


func on_event_clear():
	# print_debug("Event: reset")
	event_coords_label.text = str("")

func on_event_focused(coords:Vector2):
	# print_debug("Event: %s.%s" % [coords.x, coords.y])
	var event = TheTown.get_nodes().get_event(coords)
	if event != null: event_coords_label.text = event.name
	#event_coords_label.text = str("Location: %s.%s" % [coords.x, coords.y])

func on_event_selected(coords:Vector2):
	# TODO: Enter event dialog mode
	expedition_popup.popup()
	expedition_popup.coords = coords
	var event = TheTown.get_nodes().get_event(coords)
	# print_debug("Event: %s.%s" % [coords.x, coords.y])
	if event != null: 
		event_coords_label.text = event.name
		expedition_popup.set_info(event.name, event.descr)


func on_start_expedition(coords):
	#var coords = expedition_popup.coords
	expedition_popup.coords = null
	expedition_popup.visible = false
	TheTown.start_selected_event(coords)

func on_cancel_expedition():
	if expedition_popup.coords != null:
		var coords = expedition_popup.coords
		expedition_popup.coords = null
		expedition_popup.visible = false
		TheTown.cancel_selected_event(coords)

func setup_event_list():
	for box in map_list.get_children():
		box.queue_free()
	var scenes = TheTown.get_events().scenes
	for key in scenes:
		var box = map_box.instance()
		box.initialize(key, scenes[key])
		box.connect("start_expedition", self, "on_start_expedition")
		map_list.add_child(box)
	var list = map_list.get_children()
	list.sort_custom(self, 'map_sort')
	for object in list: object.raise()


func _on_game_goals_updated(goals):
	# if maps_label == null: maps_label = get_node("%MapsValue")
	# if lore_label == null: lore_label = get_node("%LoreValue")
	# if boss_label == null: boss_label = get_node("%BossValue")
	maps_label.text = "%s/%s" % [goals.maps.done, goals.maps.total]
	lore_label.text = "%s/%s" % [goals.event.lore.done, goals.event.lore.total]
	boss_label.text = "%s/%s" % [goals.banish.boss.done, goals.banish.boss.total]


static func map_sort(a, b) -> bool:
	return a._order > b._order
