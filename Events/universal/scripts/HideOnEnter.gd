extends DareEvent

# Note: This is a Hide Spot, and it is always open
# Note: The player is not informed unless he is found.

func reward(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the DareEvent.reward() method" % name)
	return null

func penalty(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the DareEvent.penalty() method" % name)
	return null
