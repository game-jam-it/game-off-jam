extends ExpeditionEvent

onready var mallus = get_node("%Mallus")

func _ready():
	self._setup()
	mallus.connect("enemy_died", self, "_on_mallus_died")

func _on_mallus_died(entity):
	mallus.disconnect("enemy_died", self, "_on_mallus_died")
	print("[%s] TODO _on_mallus_died events" % [name])
	# TODO: Dimm the glow on the fontain
	# TODO: Mark Points of Intrest
	# TODO: Kill all others
	self.mark_complete()
