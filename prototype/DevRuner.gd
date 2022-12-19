extends Node2D

var team_turns = true

func _ready():
	# Jsut let all the rest pass and run
	yield(get_tree().create_timer(1.0), "timeout")
	var map = get_owner()
	if map == null:
		return push_error("[Error] map is null")
	map.initialize()
	map.enter_map(team_turns)
