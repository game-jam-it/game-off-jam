extends Node

const SAVE_FILE_PATH = "user://user.settings"

var settings = {
	"fps": false,
	"vsync": true,
	"fullscreen": false,
	"brightness": 100,
	"volume_sfx": 10,
	"volume_music": 10,
	"volume_master": 10,
}

# TODO Fullscreen Event -> Adjust camera and assets?
# TODO Brightness Event -> Game Vignette & UI Filters?

signal show_settings()

signal show_fps(value)
signal set_brightness(value)
signal update_fullscreen(value)

func _ready():
	_load_settings()

func _load_settings():
	var file = File.new()
	if !file.file_exists(SAVE_FILE_PATH):
		return

	file.open(SAVE_FILE_PATH, File.READ)
	var path = file.get_path_absolute()
	print("Load settings: %s" % path)
	var file_data = file.get_var()
	file.close()

	toggle_fps(file_data.fps)
	toggle_vsync(file_data.vsync)
	toggle_fullscreen(file_data.fullscreen)
	update_brightness(file_data.brightness)
	update_master_volume(file_data.volume_sfx)
	update_music_volume(file_data.volume_music)
	update_sfx_volume(file_data.volume_master)

func _save_settings():
	var file = File.new()
	file.open(SAVE_FILE_PATH, File.WRITE)
	file.store_var(settings)
	file.close()

func show_settings():
	emit_signal("show_settings")

func toggle_fps(value):
	if settings.fps != value:
		emit_signal("show_fps", value)
		settings.fps = value
		_save_settings()

func toggle_vsync(value):
	if settings.vsync != value:
		OS.vsync_enabled = value
		settings.vsync = value
		_save_settings()

func toggle_fullscreen(value):
	if settings.fullscreen != value:
		emit_signal("update_fullscreen", value)
		OS.window_fullscreen = value
		OS.window_borderless = value
		settings.fullscreen = value
		_save_settings()

func update_brightness(value):
	if settings.brightness != value:
		emit_signal("set_brightness", value)
		settings.brightness = value
		_save_settings()

func update_master_volume(value):
	# TODO Implement: Depends on FMOD Integration Setup
	if settings.volume_master != value:
		AudioServer.set_bus_volume_db(0, value)
		settings.volume_master = value
		print("Volume: %s" % value)
		_save_settings()

func update_music_volume(value):
	# TODO Implement: Depends on FMOD Integration Setup
	if settings.volume_music != value:
		settings.volume_music = value
		_save_settings()

func update_sfx_volume(value):
	# TODO Implement: Depends on FMOD Integration Setup
	if settings.volume_sfx != value:
		settings.volume_sfx = value
		_save_settings()
