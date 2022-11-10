extends Control

onready var expedition_dialog = $ExpeditionDialog
onready var event_coords_label = get_node("%EventCoordsLabel")

func _ready():
	TheTown.connect("event_clear", self, "on_event_clear")
	TheTown.connect("event_focused", self, "on_event_focused")
	TheTown.connect("event_selected", self, "on_event_selected")

	#expedition_dialog.connect("popup_hide", self, "on_close_expedition")
	expedition_dialog.connect("start_expedition", self, "on_start_expedition")
	expedition_dialog.connect("cancel_expedition", self, "on_cancel_expedition")


func on_event_clear():
	# print_debug("Event: reset")
	event_coords_label.text = str("")

func on_event_focused(coords:Vector2):
	# print_debug("Event: %s.%s" % [coords.x, coords.y])
	event_coords_label.text = str("Location: %s.%s" % [coords.x, coords.y])

func on_event_selected(coords:Vector2):
	# TODO: Enter event dialog mode
	# print_debug("Event: %s.%s" % [coords.x, coords.y])
	expedition_dialog.popup()
	expedition_dialog.active = true
	event_coords_label.text = str("Selected: %s.%s" % [coords.x, coords.y])


func on_start_expedition():
	expedition_dialog.active = false
	expedition_dialog.visible = false
	TheTown.start_selected_event()

func on_cancel_expedition():
	if expedition_dialog.active:
		expedition_dialog.active = false
		expedition_dialog.visible = false
		TheTown.cancel_selected_event()