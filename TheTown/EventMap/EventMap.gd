class_name EventMap
extends Node2D


var is_active = false

onready var grid = $Grid
onready var queue = $Queue
onready var spawns = $Spawns

export(String) var map_title = "Unknown"
export(String, MULTILINE) var map_summary = "An unknown map"

export var map_objectives = {
	"lore": {
		"done": 0,
		"total": 1,
	},
	"relic": {
		"done": 0,
		"total": 2,
	},
	"banish": {
		"done": 0,
		"total": 4,
	},
}

func _ready():
	queue.initialize(grid)
	queue.connect("queue_changed", self, "on_queue_changed")
	queue.connect("active_changed", self, "on_active_changed")

"""
	Handle Event State
"""

func end_event():
	queue.disable()
	self.is_active = false
	print("Ending Event: %s" % name)

func start_event():
	queue.enable()
	self.is_active = true
	yield(get_tree(), "idle_frame")
	print("Starting Event: %s" % name)
	yield(run_event(), "completed")

func run_event():
	# Note: Clearing the Queue is critical
	# Yield on events is not be cleared untill
	# the event is triggered, check all children!
	yield(queue.play_turn(), "completed")
	if is_active: yield(run_event(), "completed")

"""
	Handle Queue Updates
"""

func on_queue_changed(list):
		# TODO Update UI
	for e in list:
		print("List: %s (%s)" % [e.name, e.initiative])

func on_active_changed(active):
	if active != null:
		print("Active: %s (%s)" % [active.name, active.initiative])
