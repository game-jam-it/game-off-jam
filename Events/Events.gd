extends Node2D

# TODO Setup an acceptable offset array. Goal
# create more randomized logical loccation for.

var key = [{
	"size": 2,
	"order": 90,
	"locked": false,
	"offset": Vector2(55.0,-10.0),
	"name": "A Home",
	"descr": "A small dweling, you have a room in the atic.",
	"scene": preload("res://Events/Norman/StartDialog.tscn"),
},{
	"size": 4,
	"order": 80,
	"locked": true,
	"offset": Vector2(45.0,-15.0),
	"name": "The Cemetary",
	"descr": "You go here to find common sense.",
	"scene": preload("res://Events/country/Cemetary.tscn"),
}]


var empty = []

var center = []

var country = [{
	"size": 2,
	"order": 0,
	"locked": true,
	"name": "Some Haunted House",
	"descr": "You should not be here, yet you are.",
	"scene": preload("res://Events/country/IntroHouse.tscn"),
}]

var outskirt = [{
	"size": 3,
	"order": 0,
	"locked": true,
	"name": "The Girls House",
	"descr": "Common sense tells you stay away, but you just have to save the town.",
	"scene": preload("res://Events/outskirt/FinalHouse.tscn"),
}]

func build_dev():
	return {
		"empty": [],
		"center": build_event_map([{
			"size": 2,
			"order": 0,
			"locked": false,
			"name": "Small Center",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		}]),
		"country": build_event_map([{
			"size": 2,
			"order": 0,
			"locked": false,
			"name": "Small County",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		}]),
		"outskirt": build_event_map([{
			"size": 2,
			"order": 0,
			"locked": false,
			"name": "Small Outskirts",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		}]),
	}

func build_maps():
	# Note: Rebuild to copy and reset the arrays
	return {
		"key": key,
		"empty": build_event_map(empty),
		"center": build_event_map(center),
		"country": build_event_map(country),
		"outskirt": build_event_map(outskirt),
	}

func build_event_map(list):
	var map = {}
	for e in list:
		if not map.has(e.size):
			map[e.size] = []
		map[e.size].append(e)
	return map
