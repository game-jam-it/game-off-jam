extends CenterContainer

onready var item_texture = $ItemTexture

var displayed_item: Item = null

const tooltip_offset = Vector2(30, 50)
var item_tooltip: Resource = preload("res://UserInterface/Tooltips/ItemTooltip.tscn")

func display_item(item: Item) -> void:
	displayed_item = item
	
	# Check if the item is not null
	if item is Item:
		item_texture.texture = item.texture
		show()
	else:
		item_texture.texture = null
		_on_ItemSlot_mouse_exited()
		hide()

func _on_ItemSlot_mouse_entered():
	# Don't do anything if no item is displayed
	if displayed_item == null:
		return
	
	# Don't create another one if one is already open
	var tooltip_node = get_node_or_null("Tooltip")
	if tooltip_node != null:
		return
	
	# Create the tooltip
	var tooltip_instance = item_tooltip.instance()
	if displayed_item is Item:
		tooltip_instance.header_text = displayed_item.name
		tooltip_instance.description_text = displayed_item.flavor
		if displayed_item is Consumable:
			tooltip_instance.shown_item = displayed_item
	else:
		tooltip_instance.header_text = "<ItemName>"
		tooltip_instance.description_text = "<ItemDescription>"
	
	tooltip_instance.rect_position = rect_global_position + tooltip_offset
	add_child(tooltip_instance)
	tooltip_instance.show()

func _on_ItemSlot_mouse_exited():
	# Remove the tooltip popup if it is open
	var tooltip_node = get_node_or_null("Tooltip")
	if tooltip_node != null:
		tooltip_node.queue_free()

func consume_item() -> void:
	# Get the index of this inventory slot
	var slot_index: int = get_index()
	var item: Item = PlayerInventory.inventory[slot_index]
	if item is Consumable:
		item.consume()
		
		PlayerInventory.remove_item(slot_index)
		_on_ItemSlot_mouse_exited()

func _on_ItemSlot_gui_input(event):
	if event is InputEventMouseButton:
		if (event.pressed and event.button_index == BUTTON_RIGHT) or (event.doubleclick and event.button_index == BUTTON_LEFT):
			consume_item()
