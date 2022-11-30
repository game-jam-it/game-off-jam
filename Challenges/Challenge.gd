class_name Challenge
extends EntityObject

const D20: int = 20

enum Attribute {
	None,
	Smarts,
	Daring,
	Fortitude,
}

export(int, 20) var difficulty = 10
export(Attribute) var attribute = Attribute.None

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func destroy():
	self.free_entity()

func disable():
	self.queue_free()

func roll():
	var boost = 0;
	match attribute:
		Attribute.Smarts: boost = ActorStats.smarts
		Attribute.Daring: boost = ActorStats.daring
		Attribute.Fortitude: boost = ActorStats.fortitude
	return difficulty < (rng.randi_range(0, D20) + boost)


func check(player: PlayerActor) -> EntityAction:
	if self.roll(): return self.reward(player)
	else: return self.penalty(player)

func reward(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the challenge.reward() method" % name)
	return null

func penalty(player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the challenge.penalty() method" % name)
	return null
