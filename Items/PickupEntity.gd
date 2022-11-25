class_name PickupEntity
extends EntityObject

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