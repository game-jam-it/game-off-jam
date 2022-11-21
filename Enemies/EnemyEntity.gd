class_name EnemyEntity
extends Entity

# This a mess, preferable this would be a resource
# the behaviour is the same as the characters yet these 
# usualy are not characters, and definitly do not have to be
	
export(String) var enemy_name = "Unknown"
export(int) var current_hearts = 1
export(int) var max_hearts = 1

export(int) var damage = 1

export(Texture) var portrait_base = preload("res://UserInterface/assets/portrait_default_flip.png")
export(Texture) var portrait_damaged = preload("res://UserInterface/assets/portrait_default_flip.png")
export(Texture) var portrait_stressed = preload("res://UserInterface/assets/portrait_default_flip.png")

func damage_player() -> void:
	ActorStats.take_damage(self)

func take_damage(damage: int) -> void:
	current_hearts -= damage
	if current_hearts <= 0:
		on_death()

func on_death() -> void:
	# TODO
	print("Enemy: " + str(enemy_name) + " died")
	return
