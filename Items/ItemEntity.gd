class_name ItemEntity
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