class_name TheTownNode
extends Node2D

const BIG_MAP = {
	"zoom": 20,
	"nodes": 192,
	"culler": 0.35,
	"spread": Vector2(620.0, 40.0),
	"center": 7680000,
	"center_offset": 384,
	"outer": 38400000,
	"outer_offset": 512,
	"edge": 89600000,
	"edge_offset": 768,
}

const SMALL_MAP = {
	"zoom": 16,
	"nodes": 96,
	"culler": 0.25,
	"spread": Vector2(160.0, 20.0),
	"center": 5120000,
	"center_offset": 384,
	"outer": 19200000,
	"outer_offset": 512,
	"edge": 51200000,
	"edge_offset": 768,
}

var map_cfg = SMALL_MAP
var draw_debug = true

onready var grid = $Grid
onready var nodes = $Events
onready var camera = $Camera
onready var creator = $Creator

func _ready():
	# TODO Move create-town-on-load 
	# to new game event from menu
	build_the_town()

func _input(event):
	if event.is_action_pressed("big_map"):
		map_cfg = BIG_MAP
	if event.is_action_pressed("small_map"):
		map_cfg = SMALL_MAP

	if creator.is_done && event.is_action_pressed("ui_select"):
		build_the_town()

func get_grid():
	return grid

func get_nodes():
	return nodes

func build_the_town():
	camera.zoom = Vector2(map_cfg.zoom, map_cfg.zoom)
	yield(creator.create_town("GameOff 2022", map_cfg), "completed")
