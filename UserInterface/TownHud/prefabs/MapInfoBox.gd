extends MarginContainer

var _coords = Vector2.ZERO

onready var _info_box = get_node("%InfoBox")

onready var _map_name_label = get_node("%MapNameValue")
onready var _objective_label = get_node("%ObjectiveValue")


func _ready():
	_info_box.connect("gui_input", self, "on_gui_input")
	_info_box.connect("mouse_exited", self, "on_mouse_exited")
	_info_box.connect("mouse_entered", self, "on_mouse_entered")

func initialize(coords: Vector2, event: EventMap):
	_coords = coords
	if _map_name_label == null:
		_map_name_label = get_node("%MapNameValue")
	if _objective_label == null:
		_objective_label = get_node("%ObjectiveValue")
	_map_name_label.text = event.map_title
	if event.has_goals():
		self._on_stats_update(event.goals())
		event.connect("stats_update", self, "_on_stats_update")


func on_mouse_exited():
	TheTown.on_event_clear(_coords)

func on_mouse_entered():
	TheTown.on_event_focused(_coords)
	print("Mouse Enter: %s" % name)

func on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		TheTown.cancel_selected_event(_coords)
		TheTown.on_event_selected(_coords)


func _on_stats_update(stats):
	var count = 0
	var total = 0
	if stats.has("lore"):
		count += stats.lore.done
		total += stats.lore.total
	if stats.has("banish"):
		count += stats.banish.done
		total += stats.banish.total
	if stats.has("pickup"):
		count += stats.pickup.done
		total += stats.pickup.total
	_objective_label.text = "%s/%s" % [count, total]
	# EXTEND: Achivement tracker all done event
