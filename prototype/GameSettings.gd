extends Node

const SAVE_FILE_PATH = "user://application.settings"

var data = {
	"fps": false,
	"vsync": true,
	"fullscreen": false,
	"brightness": 100,
	"volume_sfx": 100,
	"volume_music": 100,
	"volume_master": 100,
}

# TODO Fullscreen Event -> Adjust camera and assets?
# TODO Brightness Event -> Game Vignette & UI Filters?

signal show_fps(value)
signal set_brightness(value)
signal update_fullscreen(value)

func _ready():
	_load_data()

func _load_data():
	var file = File.new()
	if !file.file_exists(SAVE_FILE_PATH):
		return

	file.open(SAVE_FILE_PATH, File.READ)
	var file_data = file.get_var()
	file.close()

	toggle_fps(file_data.fps)
	toggle_vsync(file_data.vsync)
	toggle_fullscreen(file_data.fullscreen)
	update_brightness(file_data.brightness)
	update_master_volume(file_data.volume_sfx)
	update_music_volume(file_data.volume_music)
	update_sfx_volume(file_data.volume_master)

func _save_data():
	var file = File.new()
	file.open(SAVE_FILE_PATH, File.WRITE)
	var path = file.get_path_absolute()
	print("Settings saved: %s" % path)
	file.store_var(data)
	file.close()


func toggle_fps(value):
	if data.fps != value:
		emit_signal("show_fps", value)
		data.fps = value
		_save_data()

func toggle_vsync(value):
	if data.vsync != value:
		OS.vsync_enabled = value
		data.vsync = value
		_save_data()

func toggle_fullscreen(value):
	if data.fullscreen != value:
		emit_signal("update_fullscreen", value)
		OS.window_fullscreen = value
		OS.window_borderless = value
		data.fullscreen = value
		_save_data()

func update_brightness(value):
	if data.brightness != value:
		emit_signal("set_brightness", value)
		data.brightness = value
		_save_data()

func update_master_volume(value):
	# TODO Implement: Depends on FMOD Integration Setup
	if data.volume_master != value:
		data.volume_master = value
		_save_data()

func update_music_volume(value):
	# TODO Implement: Depends on FMOD Integration Setup
	if data.volume_music != value:
		data.volume_music = value
		_save_data()

func update_sfx_volume(value):
	# TODO Implement: Depends on FMOD Integration Setup
	if data.volume_sfx != value:
		data.volume_sfx = value
		_save_data()
