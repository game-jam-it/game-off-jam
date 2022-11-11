extends Item
class_name ConsumableItem

export(String) var effect_description = ""
export(int) var cost = 1

# Resources for more advanced effects
export(Array, Resource) var consume_effects

func consume() -> void:
	for effect in consume_effects:
		if effect != null and effect.has_method("trigger_effect"):
			effect.trigger_effect(self)
