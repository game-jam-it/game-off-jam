extends EntityAction

var target: Entity
var location: Vector2

func execute():
	if entity == null:
		yield(get_tree(), "idle_frame")
		return false
	print("%s Attack damage not implemented" % name)
	# Get direction and animate an attack move
	# Damage the target and maybe kill it
	yield(get_tree(), "idle_frame")
	return true