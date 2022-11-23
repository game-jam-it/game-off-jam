extends Node

var dialogue_box: Resource = preload("res://UserInterface/DialogueSystem/DialogueBox.tscn")

func show_dialogue(filename: String) -> void:
	var dialogue_box_instance = dialogue_box.instance()
	dialogue_box_instance.filename = filename
	Overlay.add_child(dialogue_box_instance)
