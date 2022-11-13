extends ConsumableEffect
class_name StressReductionEffect

export(int) var stress_reduction: int = 1

func trigger_effect(_consumable_item: ConsumableItem) -> void:
	ActorStats.current_stress -= stress_reduction
