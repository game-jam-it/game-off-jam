extends GridContainer

export(Array, Resource) var items: Array = []

func _ready():
	update_item_grid()
	DialogueSystem.shop_items = items

func update_item_grid() -> void:
	for item_slot in items.size():
		update_inventory_slot(item_slot)

func update_inventory_slot(slot: int) -> void:
	var item: Item = items[slot]
	var shop_display_slot: Node = get_child(slot)
	shop_display_slot.display_item(item)
