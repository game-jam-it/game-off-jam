extends Control

onready var actorname_label = $BaseInfo/ActorNameLabel
onready var small_ui = $SmallUIBorder
onready var expanded_ui = $ExpandedUIBorder

var character_name: String = "" setget set_character_name
var expanded: bool = false

func _ready():
	if ActorStats.character != null:
		self.character_name = ActorStats.character.name
	
	ActorStats.connect("character_changed", self, "on_character_changed")
	DialogueSystem.show_dialogue("dialogue0")

func set_character_name(name: String) -> void:
	character_name = name
	actorname_label.text = name

func on_character_changed(character: Character) -> void:
	set_character_name(character.name)

func toggle_expanded_ui() -> void:
	expanded_ui.visible = !expanded_ui.visible
	small_ui.visible = !small_ui.visible

func _on_MaximizeButton_pressed():
	expanded_ui.visible = true
	small_ui.visible = false

func _on_MinimizeButton_pressed():
	expanded_ui.visible = false
	small_ui.visible = true
