class_name ZombieEntity
extends EnemyActor

# TODO On death respawn x turns
# Waiting for knock back on this

func investigate_smell(entity: BaseEntity):
	if hidden:
		return
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
	print("[%s] Noise tigger: '%s'" % [name, entity.name])
	if self.input.has_method("set_trigger") && self._is_cell_free():
		self.input.set_trigger(entity)
		self._unhide_zombie()

func linked_trigger(entity: BaseEntity):
	print("[%s] Linked tigger: '%s'" % [name, entity.name])
	if self._is_cell_free(): 
		self._unhide_zombie()
		return true
	return false

func _unhide_zombie():
	$Sprite.visible = true
	$Input.visible = true
	self.unhide_entity()
	var center = self.get_grid_cell()
	for hex in center.get_all_within(4):
		var coords = hex.get_axial_coords()
		var cell = _grid.get_cell_state(coords)
		if cell.state == EventGrid.CellState.Entity:
			if cell.entity.group == BaseEntity.Group.Player:
				if self.input.has_method("set_target"):
					self.input.set_target(cell.entity)

func _is_cell_free() -> bool:
	var hex = self.get_grid_cell()
	var coords = hex.get_axial_coords()
	var grid_cell = self._grid.get_cell_state(hex.get_axial_coords())
	return grid_cell.state != EventGrid.CellState.Entity
