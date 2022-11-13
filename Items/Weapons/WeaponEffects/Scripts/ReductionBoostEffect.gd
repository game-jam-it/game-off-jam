extends WeaponEffect
class_name ReductionBoostEffect

# How much to increase reduction by
export(int) var reduction_boost: int = 1
# Increase the reduction for every x of the stat you have
export(int) var every_x_stat: int = 1
# If the reduction is based on this stat
export(bool) var fortitude: bool = false
export(bool) var daring: bool = false
export(bool) var smarts: bool = false

func trigger_effect(weapon: Weapon) -> void:
	var reduction_increase: int = 0
	
	if fortitude:
		reduction_increase += floor(ActorStats.fortitude / every_x_stat) * reduction_boost
	if daring:
		reduction_increase += floor(ActorStats.daring / every_x_stat) * reduction_boost
	if smarts:
		reduction_increase += floor(ActorStats.smarts / every_x_stat) * reduction_boost
	
	weapon.reduction = weapon.base_reduction + reduction_increase
