class_name RatEntity
extends EnemyActor

func investigate_smell(entity: BaseActor):
	if _grid == null:
		print_debug("[%s]: no grid set" % name)
		return
	if entity == null:
		print_debug("[%s]: not an entity" % name)
		return
	if entity.group != BaseEntity.Group.Player:
		return
	if self.input.has_method("set_target"):
		self.input.set_target(entity)

func noise_trigger(entity: BaseEntity):
	print("[%s] Linked tigger: '%s'" % [name, entity.name])
	self.input.set_trigger(entity)
