class_name DareEvent
extends BaseEntity

const D20: int = 20

enum Attribute {
	None,
	Smarts,
	Daring,
	Fortitude,
}

var _done = false

var rng = RandomNumberGenerator.new()

signal ended(event)
signal started(event)

export(int, 20) var difficulty = 10
export(Attribute) var attribute = Attribute.None


func is_done():
	return _done


func _ready():
	rng.randomize()


func destroy():
	free_entity()

func disable():
	queue_free()


func end():
	emit_signal("ended", self)

func start():
	emit_signal("started", self)


func roll(player: PlayerActor) -> EntityAction:
	if _roll(): return _reward(player)
	else: return _penalty(player)


func _roll():
	var boost = 0;
	match attribute:
		Attribute.Smarts: boost = PlayerStats.smarts
		Attribute.Daring: boost = PlayerStats.daring
		Attribute.Fortitude: boost = PlayerStats.fortitude
	return difficulty < (rng.randi_range(0, D20) + boost)

func _reward(_player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the DareEvent.reward() method" % name)
	return null

func _penalty(_player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the DareEvent.penalty() method" % name)
	return null
