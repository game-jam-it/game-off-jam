extends DareEvent

# Note: This is a Hidden Place, but only after kill
# Note: The player is not informed unless he is found.

func reward(_player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the DareEvent.reward() method" % name)
	return null

func penalty(_player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the DareEvent.penalty() method" % name)
	return null
