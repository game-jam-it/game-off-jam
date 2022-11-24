extends Node2D

var empty = []


var center = []


var country = [{
	"size": 4,
	"name": "A Cemetary",
	"descr": "You go here to find common sense.",
	"scene": preload("res://Events/country/Cemetary.tscn"),
},{
	"size": 2,
	"name": "Haunted House",
	"descr": "You should not be here, yet you are.",
	"scene": preload("res://Events/country/IntroHouse.tscn"),
}]

var outskirt = [{
	"size": 3,
	"name": "The Girls House",
	"descr": "Common sense tells you stay away, but you just have to save the town.",
	"scene": preload("res://Events/outskirt/FinalHouse.tscn"),
}]

func build_dev():
	return {
		"empty": [],
		"center": build_event_map([{
			"size": 2,
			"name": "Small Center",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		}]),
		"country": build_event_map([{
			"size": 2,
			"name": "Small County",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		},{
			"size": 3,
			"name": "Demo Cemetery",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/DemoCemetery-S2.tscn"),
		}]),
		"outskirt": build_event_map([{
			"size": 2,
			"name": "Small Outskirts",
			"descr": "You should not be here, yet you are.",
			"scene": preload("res://Events/devroom/SmallDevRoom.tscn"),
		}]),
	}

func build_maps():
	# Note: Rebuild to copy and reset the arrays
	return {
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