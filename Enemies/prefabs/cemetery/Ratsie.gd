class_name RatEntity
extends EnemyEntity

func investigate_smell(entity: EntityActor):
	if _grid == null:
		print("> %s: no grid set" % name)
		return
	if entity == null:
		print("> %s: not an entity" % name)
		return
	if entity.group != EntityObject.Group.Player:
		#print("> %s: not a player" % name)
		return
	#print("> %s: It smells like some nerd" % name)
	if self.input.has_method("set_target"):
		self.input.set_target(entity)
