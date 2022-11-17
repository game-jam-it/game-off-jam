class_name EventMap
extends Node2D

# TODO On Ready
# - Spawn player on to the map
# - Add player to the queue**

# TODO On Actor Moved -> update grid
# TODO Put initial actors on ot the grid

var is_active = false

onready var grid = $Grid
onready var queue = $Queue
onready var spawns = $Spawns

func _ready():
	queue.visible = false
	queue.connect("queue_changed", self, "on_queue_changed")
	queue.connect("active_changed", self, "on_active_changed")

"""
	Handle Event State
"""

func end_event():
	queue.visible = false
	self.is_active = false
	print("Ending Event: %s" % name)

func start_event():
	queue.inti(grid)
	queue.visible = true
	self.is_active = true
	print("Starting Event: %s" % name)
	yield(run_event(), "completed")

func run_event():
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
