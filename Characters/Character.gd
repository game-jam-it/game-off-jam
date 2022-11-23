extends Resource
class_name Character

export(String) var name = ""
export(String) var unique_effect_description = ""
export(int) var max_hp = 1
export(int) var speed = 3
export(int) var fortitude = 1
export(int) var daring = 1
export(int) var smarts = 1

# Base items when starting out
export(Array, Resource) var items

# Resources for the advanced effects
export(Array, Resource) var character_effects

# UI Textures used as character portreits
export(Texture) var portrait_base = preload("res://UserInterface/assets/portrait_default.png")
export(Texture) var portrait_damaged = preload("res://UserInterface/assets/portrait_default.png")
export(Texture) var portrait_stressed = preload("res://UserInterface/assets/portrait_default.png")

func activate_effect() -> void:
	for effect in character_effects:
		if effect != null and effect.has_method("trigger_effect"):
			effect.trigger_effect(self)
