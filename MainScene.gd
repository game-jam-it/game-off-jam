extends Control

func _ready():
	TheTown.connect("town_generated", self, "_on_town_generated")
	# TODO Handle player being faster than the generator
	# and run town generator while player selects actor
	TheTown.start_map_generator()

func _on_town_generated():
	Overlay.start_game_intro()
