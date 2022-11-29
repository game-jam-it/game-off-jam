class_name EventMap
extends Node2D

enum Type {
	None,
	Dialogue,
	Expedition
}

# FixMe The map stats, locked is in 3 places
# but only this one gets updated with events

var order = 0

var _type = Type.None
var _coords = Vector2.ZERO

var _goals = null
var _locked = true
var _complete = false

signal map_unlocked(map)
signal map_conpleted(map)
signal stats_updated(stats)

export(String) var map_title = "Unknown"
export(String, MULTILINE) var map_summary = "An unknown map"

func type():
	return _type

func goals():
	return _goals

func coords():
	return _coords

func has_goals():
	return self._goals != null

func is_locked():
	return self._locked

func is_complete():
	return self._complete


func unlock():
	if self._locked:
		self._locked = false
		emit_signal("map_unlocked", self)

func mark_complete():
	if !self._complete:
		self._complete = true
		emit_signal("map_conpleted", self)


func end_event():
	print("%s missing overwrite of the EventMap.end_event() method" % name)

func start_event():
	print("%s missing overwrite of the EventMap.start_event() method" % name)

func set_info(node):
	order = node.info.order
	_coords = node.coords
	_locked = node.info.locked
	map_title = node.info.name
	map_summary = node.info.descr
	self.position = node.position

"""
	Event Map Base Goals
"""

static func new_goals():
	return {
		"lore": {"done": 0, "total": 0,},
		"banish": {
			"done": 0, "total": 0,
			"boss": {"done": 0, "total": 0,},
			"drone": {"done": 0, "total": 0,},
		},
		"pickup": {
			"done": 0, "total": 0,
			"relic": {"done": 0, "total": 0,},
			"money": {"done": 0, "total": 0,},
			"weapon": {"done": 0, "total": 0,},
			"trinket": {"done": 0, "total": 0,},
			"consumable": {"done": 0, "total": 0,},
		},
		"challenge": {
			"done": 0, "total": 0,
			"hide": {"done": 0, "total": 0,},
			"escape": {"done": 0, "total": 0,},
		},
	}
