extends Node2D

var empty = []


var center = []


var country = [{
	"size": 4,
	"name": "Cemetary",
	"descr": "",
	"scene": preload("res://Events/country/Cemetary.tscn"),
},{
	"size": 4,
	"name": "Empty House",
	"descr": "",
	"scene": preload("res://Events/country/IntroHouse.tscn"),
}]

var outskirt = [{
	"size": 4,
	"name": "A Girls House",
	"descr": "",
	"scene": preload("res://Events/outskirt/FinalHouse.tscn"),
}]

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
