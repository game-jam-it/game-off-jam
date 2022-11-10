extends Node2D

const BIG_MAP = {
	"zoom": 16,
	"nodes": 128,
	"culler": 0.35,
	"spread": Vector2(620.0, 40.0),
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
	"spread": Vector2(160.0, 20.0),
	"grid_size": Vector2(1024.0, 576.0),
	"center": 2560000,
	"center_offset": 128,
	"outer": 7680000,
	"outer_offset": 256,
	"edge": 25600000,
	"edge_offset": 512,
}

enum TownState {
	SetMode,
	PrepMode,
	ExploreMode
}

signal event_clear(coords)
signal event_focused(coords)
signal event_selected(coords)

var map_cfg = SMALL_MAP
var draw_debug = true

onready var grid = $Grid
onready var event = $Event
onready var nodes = $Events
onready var camera = $Camera
onready var creator = $Creator

## TODO: Add initial set mode
var town_state = TownState.PrepMode
var event_coords = null

signal event_node_clear()
signal event_node_hover(coords)

func _ready():
	nodes.connect("event_clear", self, "on_event_clear")
	nodes.connect("event_focused", self, "on_event_focused")
	nodes.connect("event_selected", self, "on_event_selected")
	# TODO Move create-town-on-load 
	# to new game event from menu
	build_the_town()

func _input(input):
	if input.is_action_pressed("big_map"):
		map_cfg = BIG_MAP
	if input.is_action_pressed("small_map"):
		map_cfg = SMALL_MAP

	if creator.is_done && input.is_action_pressed("ui_select"):
		build_the_town()

	if town_state == TownState.SetMode:
		_input_set_mode(input)
	elif town_state == TownState.PrepMode:
		nodes.handle_input(input)
	elif town_state == TownState.ExploreMode:
		_input_explore_mode(input)

func _input_set_mode(_input):
	# TODO Implement _input_set_mode
	pass

func _input_explore_mode(_input):
	# TODO Implement _input_explore_mode
	pass

func get_grid():
	return grid

func get_nodes():
	return nodes

func build_the_town():
	camera.zoom = Vector2(map_cfg.zoom, map_cfg.zoom)
	yield(creator.create_town("GameOff 2022", map_cfg), "completed")

"""
	Prep-Phase Events & Logic
"""

func on_event_clear(coords):
	if !creator.is_done:
		return
	if event_coords == coords:
		event_coords = null
		emit_signal("event_clear")
	# TODO Clear Event Info

func on_event_focused(coords):
	if !creator.is_done:
		return
	if event_coords != coords:
		event_coords = coords
		emit_signal("event_focused", coords)
	# TODO Grab Display Basic Info
	#  -> On Click: 
	#    -> Show Extra Dialog
	#    -> Lock Mouse Exit
	#  -> Confirm Dialog 
	#    -> Zoom to Event
	#  -> Confirm Dialog 
	#    -> Zoom to Event

func on_event_selected(coords):
	if !creator.is_done:
		return
	if event_coords == coords:
		event_coords = coords
		emit_signal("event_selected", coords)

	## ONLY After conformation
	# Note: This is a game state change to expedition mode
	# TODO: This should just open a conformation dialog
	# See: TheTown.on_mouse_entered_event
	# if event_coords != null:
	# 	camera.zoom_to(grid.get_location(event_coords))
