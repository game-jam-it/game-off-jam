extends GridContainer

const INVENTORY_SLOTS: int = 5

func _ready():
	update_item_grid()
	PlayerInventory.connect("inventory_changed", self, "on_inventory_changed")

func on_inventory_changed(_inventory) -> void:
	update_item_grid()

func update_item_grid() -> void:
	for item_slot in PlayerInventory.inventory.size():
		update_inventory_slot(item_slot)

func update_inventory_slot(slot: int) -> void:
	var item: Item = PlayerInventory.inventory[slot]
	var inventory_display_slot: Node = get_child(slot)
	inventory_display_slot.display_item(item)
