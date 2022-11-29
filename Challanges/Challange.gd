class_name Challange
extends EntityObject

enum Attribute {
	None,
	Smarts,
	Daring,
	Fortitude,
}

export(int, 20) var difficulty = 10
export(Attribute) var attribute = Attribute.None

# So if the player enters a challange object -> roll the dice

func roll():
	# TODO Roll Dice
	pass

func reward():
	print("%s missing overwrite of the challange.reward() method" % name)

func penalty():
	print("%s missing overwrite of the challange.penalty() method" % name)
