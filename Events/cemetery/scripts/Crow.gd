extends DareEvent

var _counter: int = 0

export(int) var duration: int = 2
export(int) var max_range: int = 6

func reward(player: PlayerActor) -> EntityAction:
	self.free_entity()
	if player == null: 
		return null
	var hex = self.get_grid_cell()
	return player.get_move_to(hex)

func penalty(_player: PlayerActor) -> EntityAction:
	var center = self.get_grid_cell()
	for hex in center.get_all_within(max_range):
		var coords = hex.get_axial_coords()
		var cell = _grid.get_cell_state(coords)
		if cell.state == EventGrid.CellState.Entity:
			if cell.entity.has_method("noise_trigger"): 
				cell.entity.noise_trigger(self)
	if _counter == 0:
		TheTown.connect("next_round", self, "_on_next_round")
			
	# Get all in range and wake them up with this target
	# Timeout then vanish ...
	# setup destroy event
	return null

func _on_next_round(_count: int):
	self._counter +=1
	if self._counter > duration:
		self.destroy()
