extends CanvasLayer

onready var town_hud = $TownHud
onready var event_hud = $EventHud
onready var player_hud = $PlayerHud

func _ready():
	town_hud.disable()
	event_hud.disable()
	player_hud.disable()
	TheTown.connect("town_restart", self, "on_town_restart")
	TheTown.connect("town_generated", self, "on_town_generated")

	TheTown.connect("stop_expedition", self, "on_event_ended")
	TheTown.connect("start_expedition", self, "on_event_started")

	player_hud.connect("actor_selected", self, "on_actor_selected")

func _input(event):
	# Temp Show hide ui for debug setup
	if event.is_action_pressed("ui_page_up"):
		town_hud.enable()
		event_hud.disable()
	if event.is_action_pressed("ui_page_down"):
		town_hud.disable()
		event_hud.enable()

func on_town_restart():
	town_hud.disable()
	event_hud.disable()
	player_hud.disable()
	pass

func on_town_generated():
	player_hud.initialize()

func on_actor_selected():
	town_hud.initialize()
	event_hud.disable()
	pass

func on_event_ended(coords):
	print("%s.on_event_ended" % name)
	town_hud.enable()
	event_hud.disable()
	pass

func on_event_started(coords):
	print("%s.on_event_started" % name)
	town_hud.disable()
	event_hud.initialize(coords)
	pass
