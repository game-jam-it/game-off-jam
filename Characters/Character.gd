extends Resource
class_name Character

export(String) var name = ""
export(String) var unique_effect_description = ""
export(int) var max_hp = 1
export(int) var fortitude = 1
export(int) var daring = 1
export(int) var smarts = 1

# Base items when starting out
export(Array, Resource) var items

# Resources for the advanced effects
export(Array, Resource) var character_effects

func activate_effect() -> void:
	for effect in character_effects:
		if effect != null and effect.has_method("trigger_effect"):
			effect.trigger_effect(self)
