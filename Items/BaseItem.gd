class_name BaseItem
extends BaseEntity

enum Slot {
	None,
	Relic,
	Money,
	Weapon,
	Trinket,
	Consumable,
}

signal picked_up(entity)

export var slot = Slot.None

func pick_up():
	emit_signal("picked_up", self)
