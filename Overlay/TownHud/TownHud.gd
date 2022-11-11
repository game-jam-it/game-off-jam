extends Control

onready var expedition_popup = $ExpeditionDialog
onready var event_coords_label = get_node("%EventCoordsLabel")

func _ready():
	TheTown.connect("event_clear", self, "on_event_clear")
	TheTown.connect("event_focused", self, "on_event_focused")
	TheTown.connect("event_selected", self, "on_event_selected")

	expedition_popup.connect("start_expedition", self, "on_start_expedition")
	expedition_popup.connect("cancel_expedition", self, "on_cancel_expedition")


func on_event_clear():
	# print_debug("Event: reset")
	event_coords_label.text = str("")

func on_event_focused(coords:Vector2):
	# print_debug("Event: %s.%s" % [coords.x, coords.y])
	event_coords_label.text = str("Location: %s.%s" % [coords.x, coords.y])

func on_event_selected(coords:Vector2):
	# TODO: Enter event dialog mode
	expedition_popup.popup()
	expedition_popup.coords = coords
	# print_debug("Event: %s.%s" % [coords.x, coords.y])
	event_coords_label.text = str("Selected: %s.%s" % [coords.x, coords.y])


func on_start_expedition():
	var coords = expedition_popup.coords
	expedition_popup.coords = null
	expedition_popup.visible = false
	TheTown.start_selected_event(coords)

func on_cancel_expedition():
	if expedition_popup.coords != null:
		var coords = expedition_popup.coords
		expedition_popup.coords = null
		expedition_popup.visible = false
		TheTown.cancel_selected_event(coords)