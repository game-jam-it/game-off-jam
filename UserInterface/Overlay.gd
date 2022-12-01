extends CanvasLayer


onready var town_hud = $TownHud
onready var event_hud = $EventHud
onready var player_hud = $PlayerHud
onready var splash_hud = $SplashHud

onready var intro_norman = preload("res://Dialogue/norman/act2/intro-teens.gd")

func _ready():
	town_hud.disable()
	event_hud.disable()
	player_hud.restart()
	TheTown.connect("town_restart", self, "on_town_restart")
	TheTown.connect("town_generated", self, "on_town_generated")
	

	TheTown.connect("game_over", self, "on_game_over")
	TheTown.connect("game_pause", self, "on_game_pause")
	TheTown.connect("game_resume", self, "on_game_resume")
	TheTown.connect("game_restart", self, "on_game_restart")

	TheTown.connect("stop_expedition", self, "on_event_ended")
	TheTown.connect("start_expedition", self, "on_event_started")

	TheTown.connect("expedition_pause", self, "on_expedition_pause")
	TheTown.connect("expedition_resume", self, "on_expedition_resume")

	player_hud.connect("actor_selected", self, "on_actor_selected")


func on_town_restart():
	town_hud.disable()
	event_hud.disable()
	player_hud.restart()
	splash_hud.visible = true
	pass

func on_town_generated():
	player_hud.open_town_selection()

func on_map_selected():
	print_debug(">>> Act: %s" % TheTown.get_act())
	match TheTown.get_act():
		TheTown.Act.Into: player_hud.open_actor_selection()
		TheTown.Act.Teens: _run_teens_intro_dialog()

func on_actor_selected():
	splash_hud.visible = false
	town_hud.initialize()
	event_hud.disable()
	TheTown.start()


func on_event_ended(coords):
	town_hud.enable()
	event_hud.disable()
	pass

func on_event_started(coords):
	town_hud.disable()
	event_hud.initialize(coords)
	pass


func on_game_over():
	player_hud.open_game_over()

func on_game_pause():
	player_hud.open_game_paused()

func on_game_resume():
	player_hud.close_game_paused()

func on_game_restart():
	town_hud.disable()
	event_hud.disable()
	player_hud.restart()


func on_expedition_pause():
	player_hud.open_game_paused()

func on_expedition_resume():
	player_hud.close_game_paused()

func _run_teens_intro_dialog():
	# TODO Fix Hardcoded actor variable,
	# works because only one is available
	var box = DialogueSystem.show_dialogue(intro_norman.dialogue)
	if box != null: box.connect_signals(self)

func on_dialogue_closed():
	splash_hud.visible = false
	town_hud.initialize()
	event_hud.disable()
	TheTown.start()
