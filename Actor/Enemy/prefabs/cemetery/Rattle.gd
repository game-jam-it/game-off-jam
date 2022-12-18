class_name BonesEntity
extends EnemyActor

var smelled_it: BaseEntity = null

func clear_smell(entity: BaseEntity):
	if entity == null:
		print_debug("[%s]: not an entity" % name)
		return
	if entity.group != BaseEntity.Group.Player:
		return
	smelled_it = null

func investigate_smell(entity: BaseEntity):
	if _grid == null:
		print_debug("[%s]: no grid set" % name)
		return
	if entity == null:
		print_debug("[%s]: not an entity" % name)
		return
	if entity.group != BaseEntity.Group.Player:
		return
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
		self.input.set_target(smelled_it)
		self.smelled_it = null
		self.unhide_entity()

