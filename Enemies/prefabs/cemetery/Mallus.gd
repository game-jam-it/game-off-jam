class_name MallusEntity
extends EnemyEntity

var smelled_it: EntityObject = null

func clear_smell(entity: EntityObject):
	if entity == null:
		#print("> %s: not an entity" % name)
		return
	if entity.group != EntityObject.Group.Player:
		#print("> %s: not a player" % name)
		return
		smelled_it = null

func investigate_smell(entity: EntityObject):
	if _grid == null:
		#print("> %s: no grid set" % name)
		return
	if entity == null:
		#print("> %s: not an entity" % name)
		return
	if entity.group != EntityObject.Group.Player:
		#print("> %s: not a player" % name)
		return
	#print("> %s: It smells like something living" % name)
	smelled_it = entity

func _process(_delta):
	if smelled_it == null:
		return

	var from = self.get_grid_cell()
	var to = smelled_it.get_grid_cell()
	if 10 < _grid.get_line_of_sight_cover(from, to):
		return

	if self.input.has_method("set_target"):
		$Sprite.visible = true
		$Input.visible = true
		self.hidden = false
		self.input.set_target(smelled_it)
		smelled_it = null
		emit_signal("enemy_unhide", self)
