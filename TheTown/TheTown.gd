extends Node2D

const BIG_MAP = {
	"zoom": 16,
	"nodes": 128,
	"culler": 0.35,
	"spread": Vector2(480.0, 40.0),
	"grid_size": Vector2(1280.0, 720.0),
	"center": 7680000,
	"center_offset": 384,
	"outer": 25600000,
	"outer_offset": 512,
	"edge": 51200000,
	"edge_offset": 768,
}

const SMALL_MAP = {
	"zoom": 14,
	"nodes": 56,
	"culler": 0.25,
	"spread": Vector2(120.0, 20.0),
	"grid_size": Vector2(1024.0, 576.0),
	"center": 2560000,
	"center_offset": 128,
	"outer": 7680000,
	"outer_offset": 256,
	"edge": 25600000,
	"edge_offset": 512,
}

const MICRO_MAP = {
	"zoom": 14,
	"nodes": 28,
	"culler": 0.25,
	"spread": Vector2(60.0, 10.0),
	"grid_size": Vector2(1024.0, 576.0),
	"center": 1280000,
	"center_offset": 92,
	"outer": 3760000,
	"outer_offset": 128,
	"edge": 12800000,
	"edge_offset": 256,
}

enum TownState {
	SetMode,
	PrepMode,
	ExploreMode
}

signal town_restart
signal town_generated

signal event_clear(coords)
signal event_focused(coords)
signal event_selected(coords)

signal game_over
signal game_pause
signal game_resume

signal stop_dialogue
signal start_dialogue

signal stop_expedition
signal start_expedition

signal expedition_pause
signal expedition_resume

signal state_chaged(state)

signal game_stats_updated(stats)
signal event_stats_updated(stats)

var map_cfg = MICRO_MAP
var draw_debug = false

onready var grid = $Grid
onready var nodes = $Nodes
onready var events = $Events
onready var camera = $Camera
onready var creator = $Creator

## TODO: Add initial set mode
var paused = false
var town_state = TownState.SetMode
var event_coords = null

func _ready():
	nodes.connect("event_clear", self, "on_event_clear")
	nodes.connect("event_focused", self, "on_event_focused")
	nodes.connect("event_selected", self, "on_event_selected")
	events.connect("game_stats_updated", self, "_on_game_stats_updated")
	events.connect("event_stats_updated", self, "_on_event_stats_updated")
	events.connect("pause_explore_event", self, "on_pause_explore_event")
	# TODO Move create-town-on-load 
	# to new game event from menu
	# events.visible = false
	build_town()

func _unhandled_input(input):
	if paused:
		return
	if input.is_action_pressed("ui_home"):
		draw_debug = !draw_debug
	if town_state == TownState.SetMode:
		_input_set_mode(input)
	elif town_state == TownState.PrepMode:
		nodes.handle_input(input)
	elif town_state == TownState.ExploreMode:
		events.handle_input(input)

func _input_set_mode(input):
	if input.is_action_pressed("big_map"):
		map_cfg = BIG_MAP
	if input.is_action_pressed("small_map"):
		map_cfg = SMALL_MAP
	# TODO Fix State, paused is doubled in the hud
	if !paused && input.is_action_pressed("ui_cancel"):
		get_tree().set_input_as_handled()
		self.pause_game()
	if creator.is_done && input.is_action_pressed("rebuild_town"):
		build_town()
	elif creator.is_done && input.is_action_pressed("rebuild_devops"):
		build_devops()

func get_grid():
	return grid

func get_nodes():
	return nodes

func get_events():
	return events

func get_state():
	return town_state

func is_ready():
	return creator.is_done

func is_paused():
	return paused

func start():
	self._set_town_state(TownState.PrepMode)
	camera.zoom_reset()

func _set_town_state(state):
	town_state = state
	emit_signal("state_chaged", state)
	

func build_town():
	if !creator.is_done:
		return
	if town_state != TownState.SetMode:
		return
	emit_signal("town_restart")
	var seed_phrase = "GameOff 2022 - %s" % OS.get_unix_time()
	yield(creator.create_town(seed_phrase, map_cfg), "completed")
	self.events.initialize_stats()
	emit_signal("town_generated")

func build_devops():
	if !creator.is_done:
		return
	if town_state != TownState.SetMode:
		return
	emit_signal("town_restart")
	var seed_phrase = "DEVOPS-SEEDS"
	yield(creator.create_town(seed_phrase, MICRO_MAP), "completed")
	# TODO Compute and set the initial stats
	yield(get_tree(), "idle_frame")
	self.events.initialize_stats()
	emit_signal("town_generated")


"""
	UI Callbacks
"""

func pause_game():
	paused = true
	emit_signal("game_pause")

func resume_game():
	paused = false
	if town_state != TownState.ExploreMode:
		emit_signal("expedition_resume")
	else:
		emit_signal("game_resume")

func restart_game():
	# TODO Setup restart_game
	# TODO Destroy the old saves
	self._set_town_state(TownState.SetNode)
	self.build_town()

"""
	Global Events & Logic
"""

func _on_game_stats_updated(stats):
	emit_signal("game_stats_updated", stats)

func _on_event_stats_updated(stats):
	emit_signal("event_stats_updated", stats)

"""
	Prep-Phase Events & Logic
"""

func on_event_clear(coords):
	if !creator.is_done:
		return
	if event_coords == coords:
		event_coords = null
		emit_signal("event_clear")

func on_event_focused(coords):
	if !creator.is_done:
		return
	if event_coords != coords:
		event_coords = coords
		emit_signal("event_focused", coords)

func on_event_selected(coords):
	if !creator.is_done:
		return
	if event_coords == coords:
		event_coords = coords
		emit_signal("event_selected", coords)
	if event_coords != null:
		camera.set_focus_to(grid.get_location(event_coords))

func start_selected_event(coords):
	print("Start expedition: %s.%s" % [coords.x, coords.y])
	event_coords = coords
	emit_signal("event_focused", coords)
	self._set_town_state(TownState.ExploreMode)
	camera.set_zoom_to(grid.get_location(event_coords))
	nodes.hide_mode(coords)
	yield(get_tree(), "idle_frame")
	var type = events.start_event(coords)
	if type == EventMap.Type.Expedition:
		emit_signal("start_expedition", coords)
	elif type == EventMap.Type.Dialogue:
		emit_signal("start_dialogue", coords)
	grid.visible = false

func cancel_selected_event(coords):
	print("Cancel expedition: %s.%s" % [coords.x, coords.y])
	camera.zoom_reset()
	# TODO Implement

"""
	Expedition Phase Events & Logic
"""

func stop_active_event():
	# TODO Make sure this breaks the maps queue
	self._set_town_state(TownState.PrepMode)
	events.end_event(event_coords)
	emit_signal("stop_expedition", event_coords)
	nodes.show_mode(event_coords)
	camera.zoom_reset()
	grid.visible = true

func on_pause_explore_event():
	print("Pause expedition: %s.%s" % [event_coords.x, event_coords.y])
	emit_signal("expedition_pause")
	# TODO Asjut pause behavior
	# Current behavior is exit
	stop_active_event()
	#pause_active_event()
