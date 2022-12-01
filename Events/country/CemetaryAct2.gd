extends ExpeditionEvent

onready var bones = get_node("%Bones")
onready var player = get_node("%PlayerActor")

func _ready():
	bones.connect("enemy_died", self, "_on_bones_died")

func get_cam_target():
	return player.global_position

func _on_bones_died(entity):
	bones.disconnect("enemy_died", self, "_on_bones_died")
	print("[%s] TODO _on_bones_died events" % [name])
	# TODO: Dimm the glow on the fontain
	# TODO: Mark Points of Intrest
	# TODO: Kill all others
	self.mark_complete()
