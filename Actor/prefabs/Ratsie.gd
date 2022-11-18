class_name RatEntity
extends Entity

func investigate_smell(entity: Entity):
	if _grid == null:
		print("> %s: no grid set" % name)
		return
	if entity == null:
		print("> %s: not an entity" % name)
		return
	if entity.group != Entity.Group.Player:
		print("> %s: not a player" % name)
		return
	print("> %s: It smells like some nerd" % name)
	if self.input.has_method("set_target"):
		self.input.set_target(entity)
