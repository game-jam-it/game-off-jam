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
var locked = true

var _type = Type.None
var _goals = null

signal map_unlock(map)
signal stats_update(stats)

export(String) var map_title = "Unknown"
export(String, MULTILINE) var map_summary = "An unknown map"

func type():
	return _type

func goals():
	return _goals

func has_goals():
	return self._goals != null

func is_locked():
	return locked

func end_event():
	print("%s missing overwrite of the EventMap.end_event method" % name)

func start_event():
	print("%s missing overwrite of the EventMap.start_event method" % name)

func set_info(node):
	order = node.info.order
	locked = node.info.locked
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
