extends EntityAction

var target

func execute():
	if self.entity == null:
		return false
	
	tween.interpolate_property(entity, "position", entity.position, target, 0.6, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	yield(tween, "tween_completed")

	return true