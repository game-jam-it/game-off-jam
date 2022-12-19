extends DareEvent

var links = []

export(Array, String) var link_names = []

func _ready():
	var parent = get_parent()
	for name in link_names:
		var node: EnemyActor = parent.get_node(name)
		if node != null && node.has_method("linked_trigger"): links.append(node)
		else: print("[%s] Invalid link name: %s" % [self.name, name])

func reward(_player: PlayerActor) -> EntityAction:
	print("%s missing overwrite of the DareEvent.reward() method" % name)
	#if not triggered: triggered = true
	# TODO Spawn item from grave
	return null

func penalty(_player: PlayerActor) -> EntityAction:
	for _idx in rng.randi_range(0, 3):
		if links.size() > 0:
			var entity = links.pop_front()
			if entity.has_method("linked_trigger"): 
				entity.linked_trigger(self)
	return null
