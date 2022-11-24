extends Node2D

var start_id:int

func _ready():
	# set up FMOD
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	
	# load banks
	Fmod.load_bank("res://audio/desktop/Master.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://audio/desktop/Master.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)

	# register listener
	Fmod.add_listener(0, self)

	# connect configuration events
	AppState.connect("volume_sfx_changed", self, "_on_volume_sfx_changed")
	AppState.connect("volume_music_changed", self, "_on_volume_music_changed")
	AppState.connect("volume_master_changed", self, "_on_volume_master_changed")

	# Setup all events
	#Fmod.play_one_shot("event:/GameStart", self)
	start_id = Fmod.create_event_instance("event:/GameStart")
	Fmod.start_event(start_id)

	# set the initial volume
	self._on_volume_master_changed()

func _on_volume_sfx_changed():
	var main = (AppState.settings.volume_master *0.01)
	_update_sfx_events_volume(main, AppState.settings.volume_sfx*0.01)

func _on_volume_music_changed():
	var main = (AppState.settings.volume_master *0.01)
	_update_music_events_volume(main, AppState.settings.volume_music*0.01)

func _on_volume_master_changed():
	var main = (AppState.settings.volume_master *0.01)
	_update_sfx_events_volume(main, AppState.settings.volume_sfx*0.01)
	_update_music_events_volume(main, AppState.settings.volume_music*0.01)

func _update_sfx_events_volume(main:float, sfx:float):
	# var volume = 0.0
	# if main > 0.01 && sfx > 0.01: 
	# 	volume = (main + (sfx * 2.0)) * 0.333
	# Add sfx events here
	pass

func _update_music_events_volume(main:float, music:float):
	var volume = 0.0
	if main > 0.01 && music > 0.01: 
		volume = (main + (music * 2.0)) * 0.333
	Fmod.set_event_volume(start_id, volume)
	# Add music events here
