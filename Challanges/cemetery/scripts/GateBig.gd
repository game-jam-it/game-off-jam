extends Challange

func reward(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the challange.reward() method" % name)
	return null

func penalty(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the challange.penalty() method" % name)
	return null
