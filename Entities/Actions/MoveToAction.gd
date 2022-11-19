extends EntityAction

var location: Vector2

func execute():
	if self.entity == null:
		yield(get_tree(), "idle_frame")
		return false
	if location == entity.position:
		yield(get_tree(), "idle_frame")
		return false

	tween.interpolate_property(entity, "position", entity.position, location, 0.6, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(tween, "tween_completed")
	location = entity.position
	return true
