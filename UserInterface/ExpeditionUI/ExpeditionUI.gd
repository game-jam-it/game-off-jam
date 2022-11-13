extends Control

onready var actorname_label = $BackgroundRect/ActorName

var character_name: String = "" setget set_character_name

func _ready():
	if ActorStats.character != null:
		self.character_name = ActorStats.character.name
	
	ActorStats.connect("character_changed", self, "on_character_changed")

func set_character_name(name: String) -> void:
	character_name = name
	actorname_label.text = name

func on_character_changed(character: Character) -> void:
	set_character_name(character.name)
