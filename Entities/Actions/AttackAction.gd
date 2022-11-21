extends EntityAction

var target: EntityObject
var location: Vector2

func execute():
	if entity == null or target == null:
		yield(get_tree(), "idle_frame")
		return false
	print("[%s] TODO Implement attack animation" % name)
	# Get direction and animate an attack move
	# Damage the target and maybe kill it
	# TODO Implement attack animation
	if target.group == EntityObject.Group.Player:
		return attack_player_target()
	if target.group == EntityObject.Group.Enemy:
		return attack_enemy_target()
	yield(get_tree(), "idle_frame")
	return false

func attack_enemy_target():
	target.take_damage(ActorStats.get_damage())
	yield(get_tree(), "idle_frame")
	return true

func attack_player_target():
	ActorStats.take_damage(entity.damage)
	yield(get_tree(), "idle_frame")
	return true
