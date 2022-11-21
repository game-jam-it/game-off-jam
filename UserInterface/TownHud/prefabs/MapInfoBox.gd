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
	var count = 0
	var total = 0
	if event.map_objectives.has("lore"):
		count += event.map_objectives.lore.done
		total += event.map_objectives.lore.total
	if event.map_objectives.has("relic"):
		count += event.map_objectives.relic.done
		total += event.map_objectives.relic.total
	if event.map_objectives.has("banish"):
		count += event.map_objectives.banish.done
		total += event.map_objectives.banish.total
	_objective_label.text = "%s/%s" % [count, total]
	# TODO Subscribe to event


func on_mouse_exited():
	TheTown.on_event_clear(_coords)

func on_mouse_entered():
	TheTown.on_event_focused(_coords)
	print("Mouse Enter: %s" % name)

func on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		TheTown.cancel_selected_event(_coords)
		TheTown.on_event_selected(_coords)
