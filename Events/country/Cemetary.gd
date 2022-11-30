extends ExpeditionEvent

onready var mallus = get_node("%Mallus")
onready var player = get_node("%PlayerActor")

func _ready():
	mallus.connect("enemy_died", self, "_on_mallus_died")

func get_cam_target():
	return player.global_position

func _on_mallus_died(entity):
	mallus.disconnect("enemy_died", self, "_on_mallus_died")
	print("[%s] TODO _on_mallus_died events" % [name])
	# TODO: Dimm the glow on the fontain
	# TODO: Mark Points of Intrest
	# TODO: Kill all others
	self.mark_complete()
