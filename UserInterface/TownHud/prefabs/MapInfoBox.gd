extends MarginContainer

var _order = 0
var _locked = 0
var _coords = Vector2.ZERO

onready var _info_box = get_node("%InfoBox")

onready var _locked_box = get_node("%LockedBox")
onready var _objective_box = get_node("%ObjectiveBox")

onready var _map_name_label = get_node("%MapNameValue")
onready var _objective_label = get_node("%ObjectiveValue")


func _ready():
	_info_box.connect("gui_input", self, "on_gui_input")
	_info_box.connect("mouse_exited", self, "on_mouse_exited")
	_info_box.connect("mouse_entered", self, "on_mouse_entered")

func initialize(coords: Vector2, map: EventMap):
	_coords = coords
	self._order = map.order
	self._locked = map.is_locked()
	# This can be called before it is ready
	_locked_box = get_node("%LockedBox")
	_objective_box = get_node("%ObjectiveBox")
	_map_name_label = get_node("%MapNameValue")
	_objective_label = get_node("%ObjectiveValue")
	_map_name_label.text = map.map_title
	if self._locked:
		map.connect("map_unlocked", self, "_on_map_unlocked")
		self.modulate = Color(0.6, 0.6, 0.6)
		_objective_box.visible = false
		_locked_box.visible = true
	else:
		self.modulate = Color(1.0, 1.0, 1.0)
		_objective_box.visible = true
		_locked_box.visible = false
	if map.has_goals():
		map.connect("stats_updated", self, "_on_stats_updated")
		self._on_stats_updated(map.goals())


func on_mouse_exited():
	TheTown.on_event_clear(_coords)

func on_mouse_entered():
	TheTown.on_event_focused(_coords)

func on_gui_input(event):
	if _locked:
		# TODO [AUDIO]: Play locked sound
		return
	if TheTown.is_paused():
		return
	if event is InputEventMouseButton and event.pressed:
		TheTown.cancel_selected_event(_coords)
		TheTown.on_event_selected(_coords)


func _on_map_unlocked(map):
	map.disconnect("map_unlocked", self, "_on_map_unlocked")
	_locked = false
	_locked_box.visible = false
	_objective_box.visible = true
	self.modulate = Color(1.0, 1.0, 1.0)

func _on_stats_updated(stats):
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
