extends MarginContainer

var _order = 0
var _locked = 0
var _coords = Vector2.ZERO

signal start_expedition(coords)

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
		map.connect("goals_updated", self, "_on_goals_updated")
		self._on_goals_updated(map.goals())


func on_mouse_exited():
	if TheTown.get_state() == TheTown.State.PrepMode:
		TheTown.on_event_clear(_coords)

func on_mouse_entered():
	if TheTown.get_state() == TheTown.State.PrepMode:
		TheTown.on_event_focused(_coords)

func on_gui_input(event):
	if _locked || TheTown.is_paused():
		# TODO [AUDIO]: Play locked sound
		return
	if TheTown.get_state() != TheTown.State.PrepMode:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			TheTown.cancel_selected_event(_coords)
			TheTown.on_event_selected(_coords)
		if event.doubleclick:
			emit_signal("start_expedition", _coords)

func _on_map_unlocked(map):
	map.disconnect("map_unlocked", self, "_on_map_unlocked")
	_locked = false
	_locked_box.visible = false
	_objective_box.visible = true
	self.modulate = Color(1.0, 1.0, 1.0)

func _on_goals_updated(goals):
	var count = 0
	var total = 0
	if goals.has("event"):
		count += goals.event.done
		total += goals.event.total
	if goals.has("banish"): 
		if goals.banish.has("boss"):
			count += goals.banish.boss.done
			total += goals.banish.boss.total
	_objective_label.text = "%s/%s" % [count, total]
	# EXTEND: Achivement tracker all done event
