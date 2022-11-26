extends Node

var dialogue_box: Resource = preload("res://UserInterface/DialogueSystem/DialogueBox.tscn")

var shop_items: Array = []
var selected_item: Item = null

func show_dialogue(filename: String) -> DialogueBox:
	var open_dialogue = Overlay.get_node_or_null("DialogueBox")
	if open_dialogue != null:
		print("Already have a dialogue box opened!")
		return null
	
	# Show the dialogue box
	var dialogue_box_instance = dialogue_box.instance()
	dialogue_box_instance.dialogue_file = filename
	Overlay.add_child(dialogue_box_instance)
	return dialogue_box_instance

func show_dialogue_unsafe(filename: String) -> DialogueBox:
	# Open a new dialogue box even if one is already open
	var dialogue_box_instance = dialogue_box.instance()
	dialogue_box_instance.dialogue_file = filename
	Overlay.add_child(dialogue_box_instance)
	return dialogue_box_instance

func is_dialogue_open() -> bool:
	var open_dialogue = Overlay.get_node_or_null("DialogueBox")
	if open_dialogue != null:
		return true
	return false

func select_item(item_index: int) -> void:
	if shop_items.size() >= item_index:
		selected_item = shop_items[item_index]
	else:
		selected_item = null
