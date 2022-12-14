extends Control

onready var tabs = get_node("%TabContainer")

onready var game_stats = get_node("%GameStats")
onready var event_stats = get_node("%EventStats")

onready var exit_box = get_node("%MBoxExit")
onready var restart_box = get_node("%MBoxRestart")

onready var exit_game = get_node("%ExitGame")
onready var resume_game = get_node("%ResumeGame")
onready var restart_game = get_node("%RestartGame")

onready var sfx_slider = get_node("%SfxSlider")
onready var music_slider = get_node("%MusicSlider")
onready var master_slider = get_node("%MasterSlider")
onready var brightness_slider = get_node("%BrightnessSlider")
onready var vsync_check_button = get_node("%VSyncCheck")
onready var screen_check_button = get_node("%FullscreenCheck")


func _ready():
	exit_box.visible = true
	restart_box.visible = false
	sfx_slider.value = AppState.settings.volume_sfx
	music_slider.value = AppState.settings.volume_music
	master_slider.value = AppState.settings.volume_master
	brightness_slider.value = AppState.settings.brightness
	vsync_check_button.pressed = AppState.settings.vsync
	screen_check_button.pressed = AppState.settings.fullscreen
	self.connect("gui_input", self, "_on_gui_input")
	TheTown.connect("state_chaged", self, "_on_town_state_chaged")
	if OS.get_name() == "HTML5": exit_game.disabled = true
	else: exit_game.connect("pressed", self, "_on_exit_game")
	resume_game.connect("pressed", self, "_on_resume_game")
	restart_game.connect("pressed", self, "_on_restart_game")
	sfx_slider.connect("value_changed", self, "_on_sfx_slider_changed")
	music_slider.connect("value_changed", self, "_on_music_slider_changed")
	master_slider.connect("value_changed", self, "_on_master_slider_changed")
	brightness_slider.connect("value_changed", self, "_on_brightness_slider_changed")
	vsync_check_button.connect("toggled", self, "_on_vsync_check_toggled")
	screen_check_button.connect("toggled", self, "_on_fullscreen_check_toggled")

func _unhandled_input(input):
	if TheTown.is_paused() and input.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		TheTown.resume_game()

func _on_exit_game():
	if OS.get_name() != "HTML5": get_tree().quit()
	else: exit_game.disabled = true

func _on_resume_game():
	TheTown.resume_game()
	tabs.current_tab = 0

func _on_restart_game():
	TheTown.restart_game()

func _on_town_state_chaged(state):
	if state == TheTown.State.SetMode:
		exit_box.visible = true
		restart_box.visible = false
	else:
		exit_box.visible = false
		restart_box.visible = true

	if state == TheTown.State.ExploreMode:
		exit_game.disabled = true
		game_stats.visible = false
		event_stats.visible = true
	else:
		exit_game.disabled = false
		game_stats.visible = true
		event_stats.visible = false


"""
	Audio Settings
"""

func _on_vsync_check_toggled(state:bool):
	AppState.toggle_vsync(state)

func _on_fullscreen_check_toggled(state:bool):
	AppState.toggle_fullscreen(state)

func _on_brightness_slider_changed(value:float):
	AppState.update_brightness(value)

"""
	Audio Settings
"""

func _on_sfx_slider_changed(value:float):
	AppState.update_sfx_volume(value)

func _on_music_slider_changed(value:float):
	AppState.update_music_volume(value)

func _on_master_slider_changed(value:float):
	AppState.update_master_volume(value)
