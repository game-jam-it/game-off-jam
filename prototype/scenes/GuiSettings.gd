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
	fps_check_button.pressed = GameSettings.data.fps
	vsync_check_button.pressed = GameSettings.data.vsync
	screen_check_button.pressed = GameSettings.data.fullscreen
	brightness_slider.value = GameSettings.data.brightness
	master_slider.value = GameSettings.data.volume_master
	music_slider.value = GameSettings.data.volume_music
	sfx_slider.value = GameSettings.data.volume_sfx
	popup_centered()

# Video Settings

func _on_FpsCheckButton_toggled(state:bool):
	GameSettings.toggle_fps(state)

func _on_VSyncCheckButton_toggled(state:bool):
	GameSettings.toggle_vsync(state)

func _on_ScreenCheckButton_toggled(state:bool):
	GameSettings.toggle_fullscreen(state)

func _on_BrightnessHSlider_value_changed(value:float):
	GameSettings.update_brightness(value)

# Audio Settings

func _on_MasterHSlider_value_changed(value:float):
	GameSettings.update_master_volume(value)

func _on_MusicHSlider_value_changed(value:float):
	GameSettings.update_music_volume(value)

func _on_SfxHSlider_value_changed(value:float):
	GameSettings.update_sfx_volume(value)
