extends ConsumableEffect
class_name HealingEffect

export(int) var hearts_healed: int = 1

func trigger_effect(_consumable_item: ConsumableItem) -> void:
	PlayerStats.current_hearts += hearts_healed
