extends CanvasLayer

onready var town_hud = $TownHud
onready var event_hud = $EventHud

func _ready():
	town_hud.enable()
	event_hud.disable()

func _input(event):
	# Temp Show hide ui for debug setup
	if event.is_action_pressed("ui_page_up"):
		town_hud.enable()
		event_hud.disable()
	if event.is_action_pressed("ui_page_down"):
		town_hud.disable()
		event_hud.enable()
