extends EventEntity

func reward(player: PlayerActor) -> EntityAction:
	if player == null: 
		return null
	var hex = self.get_grid_cell()
	return player.get_move_to(hex)

func penalty(player: PlayerActor) -> EntityAction:
	if player == null: 
		return null
	player.take_damage(1)
	var hex = self.get_grid_cell()
	return player.get_move_to(hex)
