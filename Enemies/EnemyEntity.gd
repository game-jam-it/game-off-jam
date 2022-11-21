class_name EnemyEntity
extends EntityObject

signal enemy_died(entity)
signal hearts_changed(entity)

# This is messy, preferable this would be a resource
# the behaviour is the same as the characters yet these 
# usualy are not characters, and definitly do not have to be

export(String) var enemy_name = "Unknown"
export(int) var current_hearts = 1
export(int) var max_hearts = 1

export(int) var damage = 1

export(Texture) var portrait_base = preload("res://UserInterface/assets/portrait_default_flip.png")
export(Texture) var portrait_damaged = preload("res://UserInterface/assets/portrait_default_flip.png")
export(Texture) var portrait_stressed = preload("res://UserInterface/assets/portrait_default_flip.png")

func take_damage(damage: int) -> void:
	print(">> %s takes %s damage" % [name, damage])
	current_hearts -= damage
	if current_hearts <= 0: on_death()
	else: emit_signal("hearts_changed", self)

func on_death() -> void:
	self.free_entity()
	print(">> %s died" % name)
	emit_signal("enemy_died", self)
	# TODO Spawn death pile on entiry spot
	print_debug("[%s] TODO Spawn splat on spot" % name)
