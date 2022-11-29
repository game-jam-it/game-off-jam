extends Challenge

func reward(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the challenge.reward() method" % name)
	return null

func penalty(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the challenge.penalty() method" % name)
	return null
