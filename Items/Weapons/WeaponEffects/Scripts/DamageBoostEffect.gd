extends WeaponEffect
class_name DamageBoostEffect

# How much to increase reduction by
export(int) var damage_boost: int = 1
# Increase the reduction for every x of the stat you have
export(int) var every_x_stat: int = 1
# If the reduction is based on this stat
export(bool) var fortitude: bool = false
export(bool) var daring: bool = false
export(bool) var smarts: bool = false

func trigger_effect(weapon: Weapon) -> void:
	var damage_increase: int = 0
	
	if fortitude:
		damage_increase += floor(ActorStats.fortitude / every_x_stat) * damage_boost
	if daring:
		damage_increase += floor(ActorStats.daring / every_x_stat) * damage_boost
	if smarts:
		damage_increase += floor(ActorStats.smarts / every_x_stat) * damage_boost
	
	weapon.damage = weapon.base_damage + damage_increase
