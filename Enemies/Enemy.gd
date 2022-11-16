extends Node
class_name Enemy

export(String) var enemy_name = ""
export(int) var current_hearts = 1
export(int) var max_hearts = 1

export(int) var damage = 1

func damage_player() -> void:
	ActorStats.take_damage(self)

func take_damage(damage: int) -> void:
	current_hearts -= damage
	
	# Check for death
	if current_hearts <= 0:
		on_death()

func on_death() -> void:
	# TODO
	print("Enemy: " + str(enemy_name) + " died")
	return
