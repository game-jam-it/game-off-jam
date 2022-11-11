extends Item
class_name Weapon

export(int) var damage = 1
# Reduction in percentages
export(int) var reduction = 0
export(String) var other_effects = ""

# Cooldown in turns
var cooldown: int = 0

var ammo_cost: int = 0
