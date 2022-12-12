extends ConsumableEffect
class_name GainRandomAmmoEffect

export(int) var minimum: int = 1
export(int) var maximum: int = 2

func trigger_effect(_consumable_item: ConsumableItem) -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random_ammo = rng.randi_range(minimum, maximum)
	
	PlayerInventory.ammo += random_ammo
