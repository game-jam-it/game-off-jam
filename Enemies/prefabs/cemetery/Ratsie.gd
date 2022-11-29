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

func noise_trigger(entity: EntityObject):
	print(">>> Set '%s' Noise tiggert to: '%s'" % [name, entity.name])
	self.input.set_trigger(entity)
