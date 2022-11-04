extends Popup

# TODO On Settings loaded, set values on nodes.

onready var fps_check_button = $TabContainer/Video/MarginContainer/GridContainer/FpsCheckButton
onready var vsync_check_button = $TabContainer/Video/MarginContainer/GridContainer/VSyncCheckButton
onready var screen_check_button = $TabContainer/Video/MarginContainer/GridContainer/ScreenCheckButton
onready var brightness_slider = $TabContainer/Video/MarginContainer/GridContainer/BrightnessHSlider

onready var master_slider = $TabContainer/Audio/MarginContainer/GridContainer/MasterHSlider
onready var music_slider = $TabContainer/Audio/MarginContainer/GridContainer/MusicHSlider
onready var sfx_slider = $TabContainer/Audio/MarginContainer/GridContainer/SfxHSlider

func _ready():
	AppState.connect("show_settings", self, "_on_show_settings")
	fps_check_button.pressed = AppState.settings.fps
	vsync_check_button.pressed = AppState.settings.vsync
	screen_check_button.pressed = AppState.settings.fullscreen
	brightness_slider.value = AppState.settings.brightness
	master_slider.value = AppState.settings.volume_master
	music_slider.value = AppState.settings.volume_music
	sfx_slider.value = AppState.settings.volume_sfx

func _on_show_settings():
	popup_centered()

# Video Settings

func _on_FpsCheckButton_toggled(state:bool):
	AppState.toggle_fps(state)

func _on_VSyncCheckButton_toggled(state:bool):
	AppState.toggle_vsync(state)

func _on_ScreenCheckButton_toggled(state:bool):
	AppState.toggle_fullscreen(state)

func _on_BrightnessHSlider_value_changed(value:float):
	AppState.update_brightness(value)

# Audio Settings

func _on_MasterHSlider_value_changed(value:float):
	AppState.update_master_volume(value)

func _on_MusicHSlider_value_changed(value:float):
	AppState.update_music_volume(value)

func _on_SfxHSlider_value_changed(value:float):
	AppState.update_sfx_volume(value)
