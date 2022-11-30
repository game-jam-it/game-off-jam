class_name PlayerActor
extends EntityActor

func take_damage(value: int):
	ActorStats.take_damage(value)
	# TODO: spawn animate hit damage
	# an other option is on_take_damage

func get_move_to(hex):
	return self.input.move_to(hex)
