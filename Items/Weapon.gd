class_name Weapon
extends Item

export(int) var base_damage = 1
var damage: int

# Reduction in percentages
export(int) var base_reduction = 0
var reduction: int

export(String) var other_effect_description = ""

# Cooldown in turns
var cooldown: int = 0

var ammo_cost: int = 0

# Resources for more advanced effects
export(Array, Resource) var other_effects

func get_effect() -> void:
	damage = base_damage
	reduction = base_reduction
	
	for effect in other_effects:
		if effect != null and effect.has_method("trigger_effect"):
			effect.trigger_effect(self)
