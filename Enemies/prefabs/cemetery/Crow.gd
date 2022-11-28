class_name CrowEntity
extends EnemyEntity

func investigate_smell(entity: EntityObject):
	if _grid == null:
		print("> %s: no grid set" % name)
		return
	if entity == null:
		print("> %s: not an entity" % name)
		return
	if entity.group != EntityObject.Group.Player:
		#print("> %s: not a player" % name)
		return
	#print("> %s: It smells like bird feed" % name)
	if self.input.has_method("set_target"):
		self.input.set_target(entity)
