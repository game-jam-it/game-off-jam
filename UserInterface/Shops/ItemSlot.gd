extends CenterContainer

var displayed_item: Item = null

onready var item_texture = $VBoxContainer/ItemTexture
onready var cost_label = $VBoxContainer/CostDisplay/CostLabel

func display_item(item: Item) -> void:
	displayed_item = item
	
	# Check if the item is not null
	if item is Item:
		item_texture.texture = item.texture
		cost_label.text = str(item.cost)
		show()
	else:
		item_texture.texture = null
		cost_label.text = ""
		hide()

func _on_ItemSlot_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			if DialogueSystem.is_dialogue_open() == false:
				DialogueSystem.select_item(get_index())
				DialogueSystem.show_dialogue("dialogue_shop_purchase")
