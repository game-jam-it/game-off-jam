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
	"nodes": 32,
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

signal stop_expedition
signal start_expedition

signal pause_expedition
signal resume_expedition

var map_cfg = MICRO_MAP
var draw_debug = true

onready var grid = $Grid
onready var nodes = $Nodes
onready var events = $Events
onready var camera = $Camera
onready var creator = $Creator

## TODO: Add initial set mode
var town_state = TownState.PrepMode
var event_coords = null

func _ready():
	nodes.connect("event_clear", self, "on_event_clear")
	nodes.connect("event_focused", self, "on_event_focused")
	nodes.connect("event_selected", self, "on_event_selected")
	events.connect("pause_explore_event", self, "on_pause_explore_event")
	# TODO Move create-town-on-load 
	# to new game event from menu
	# events.visible = false
	build_town()

func _input(input):
	if input.is_action_pressed("ui_home"):
		draw_debug = !draw_debug

	if input.is_action_pressed("big_map"):
		map_cfg = BIG_MAP
	if input.is_action_pressed("small_map"):
		map_cfg = SMALL_MAP

	# TODO: Hook Up to the initial load
	if creator.is_done && input.is_action_pressed("rebuild_town"):
		build_town()
	elif creator.is_done && input.is_action_pressed("rebuild_devops"):
		build_devops()

	if town_state == TownState.SetMode:
		_input_set_mode(input)
	elif town_state == TownState.PrepMode:
		nodes.handle_input(input)
	elif town_state == TownState.ExploreMode:
		events.handle_input(input)

func _input_set_mode(_input):
	# TODO Implement _input_set_mode
	pass

func get_grid():
	return grid

func get_nodes():
	return nodes

func get_events():
	return events

func build_town():
	if !creator.is_done:
		return
	if town_state != TownState.PrepMode:
		return
	camera.zoom_reset()
	emit_signal("town_restart")
	var seed_phrase = "GameOff 2022 - %s" % OS.get_unix_time()
	yield(creator.create_town(seed_phrase, map_cfg), "completed")
	emit_signal("town_generated")

func build_devops():
	if !creator.is_done:
		return
	if town_state != TownState.PrepMode:
		return
	camera.zoom_reset()
	emit_signal("town_restart")
	var seed_phrase = "DEVOPS-SEEDS"
	yield(creator.create_town(seed_phrase, MICRO_MAP), "completed")
	emit_signal("town_generated")

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
	town_state = TownState.ExploreMode
	emit_signal("event_focused", coords)
	camera.set_zoom_to(grid.get_location(event_coords))
	nodes.hide_mode(coords)
	events.start_event(coords)
	emit_signal("start_expedition", coords)
	grid.visible = false

func cancel_selected_event(coords):
	print("Cancel expedition: %s.%s" % [coords.x, coords.y])
	camera.zoom_reset()
	# TODO Implement


func stop_active_event():
	# TODO Make sure this breaks the maps queue
	town_state = TownState.PrepMode
	events.end_event(event_coords)
	emit_signal("stop_expedition", event_coords)
	nodes.show_mode(event_coords)
	camera.zoom_reset()
	grid.visible = true

func on_pause_explore_event():
	print("Pause expedition: %s.%s" % [event_coords.x, event_coords.y])
	emit_signal("pause_expedition")
	# TODO Asjut pause behavior
	# Current behavior is exit
	stop_active_event()

