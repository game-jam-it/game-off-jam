class_name PickupEntity
extends EntityObject

enum Slot {
	None,
	Relic,
	Money,
	Weapon,
	Tricket,
	Consumable,
}

signal picked_up(entity)

# TODO: Implement Pickup Prefabs