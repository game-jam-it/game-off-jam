class_name Consumable
extends Item

export(String) var effect_description = ""

# Resources for more advanced effects
export(Array, Resource) var consume_effects

func consume() -> void:
	for effect in consume_effects:
		if effect != null and effect.has_method("trigger_effect"):
			effect.trigger_effect(self)
