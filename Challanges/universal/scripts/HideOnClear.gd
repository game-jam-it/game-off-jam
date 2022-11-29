extends Challange

# Note: This is a Hidden Place, but only after kill
# Note: The player is not informed unless he is found.

func reward(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the challange.reward() method" % name)
	return null

func penalty(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the challange.penalty() method" % name)
	return null
