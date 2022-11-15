extends GridContainer

const INVENTORY_SLOTS: int = 5

func _ready():
	update_item_grid()
	ActorInventory.connect("inventory_changed", self, "on_inventory_changed")

func on_inventory_changed(_inventory) -> void:
	update_item_grid()

func update_item_grid() -> void:
	for item_slot in ActorInventory.inventory.size():
		update_inventory_slot(item_slot)

func update_inventory_slot(slot: int) -> void:
	var item: Item = ActorInventory.inventory[slot]
	var inventory_display_slot: Node = get_child(slot)
	inventory_display_slot.display_item(item)
