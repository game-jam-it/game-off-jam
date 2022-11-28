extends Node2D

# TODO Setup an acceptable offset array. Goal
# create more randomized logical loccation for.

func build_events(act):
	match act:
		TheTown.Act.Into: return _build_intro_event_list()
		TheTown.Act.Teens: return _build_teens_event_list()
	print_debug("[CRIT] - Undefined TheTown.Act")
	return []

func _build_event_map(prim, second):
	var map = {}
	for e in prim:
		if not map.has(e.size):
			map[e.size] = []
		map[e.size].append(e)
	for e in second:
		if not map.has(e.size):
			map[e.size] = []
		map[e.size].append(e)
	return map

func _build_intro_event_list():
	return {
		"key": _into_key,
		"empty": _build_event_map([], _empty_base),
		"center": _build_event_map([], _center_base),
		"country": _build_event_map([], _country_base),
		"outskirt": _build_event_map([], _outskirt_base),
	}

func _build_teens_event_list():
	return {
		"key": _teens_key,
		"empty": _build_event_map([], _empty_base),
		"center": _build_event_map([], _center_base),
		"country": _build_event_map([], _country_base),
		"outskirt": _build_event_map([], _outskirt_base),
	}

func build_dev():
	return {
		"empty": [],
		"center": _build_event_map([{
			"size": 2,
			"order": 0,
			"locked": false,
			"name": "Small Center",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		}], []),
		"country": _build_event_map([{
			"size": 2,
			"order": 0,
			"locked": false,
			"name": "Small County",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		}], []),
		"outskirt": _build_event_map([{
			"size": 2,
			"order": 0,
			"locked": false,
			"name": "Small Outskirts",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		}], []),
	}


"""
	Into Act
"""

var _into_key = [{
	"size": 2,
	"order": 90,
	"locked": false,
	"offset": Vector2(55.0,-10.0),
	"name": "A Home",
	"descr": "A small dweling, you have a room in the atic.",
	"scene": preload("res://Events/norman/HomeDialog.tscn"),
},{
	"size": 4,
	"order": 80,
	"locked": true,
	"offset": Vector2(45.0,-15.0),
	"name": "The Cemetary",
	"descr": "You go here to find common sense.",
	"scene": preload("res://Events/country/Cemetary.tscn"),
}]

"""
	Teens Act
"""

var _teens_key = [{
	"size": 2,
	"order": 90,
	"locked": false,
	"offset": Vector2(-55.0,-10.0),
	"name": "A Home",
	"descr": "A small dweling, you have a room in the atic.",
	"scene": preload("res://Events/norman/act2/HomeDialog.tscn"),
},{
	"size": 4,
	"order": 80,
	"locked": false,
	"offset": Vector2(-45.0,-15.0),
	"name": "The Cemetary",
	"descr": "You go here to find common sense.",
	"scene": preload("res://Events/country/act2/Cemetary.tscn"),
}]

"""
	Generalized Slots
"""

var _empty_base = []

var _center_base = []

var _country_base = [{
	"size": 2,
	"order": 0,
	"locked": true,
	"name": "Some Haunted House",
	"descr": "You should not be here, yet you are.",
	"scene": preload("res://Events/country/IntroHouse.tscn"),
}]

var _outskirt_base = [{
	"size": 3,
	"order": 0,
	"locked": true,
	"name": "The Girls House",
	"descr": "Common sense tells you stay away, but you just have to save the town.",
	"scene": preload("res://Events/outskirt/FinalHouse.tscn"),
}]
