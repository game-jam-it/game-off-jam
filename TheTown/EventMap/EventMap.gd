class_name EventMap
extends Node2D

enum Type {
	None,
	Dialogue,
	Expedition
}

var _type = Type.None
var _goals = null

signal stats_update(stats)

export(String) var map_title = "Unknown"
export(String, MULTILINE) var map_summary = "An unknown map"

func type():
	return _type

func goals():
	return _goals

func has_goals():
	return self._goals != null

func end_event():
	print("%s missing overwrite of the EventMap.end_event method" % name)

func start_event():
	print("%s missing overwrite of the EventMap.start_event method" % name)


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
