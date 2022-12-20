class_name PlayerActor
extends ActorEntity

signal player_died(actor)
signal hearts_changed(actor)


func _ready():
	PlayerStats.connect("player_died", self, "_on_player_died")
	PlayerStats.connect("hearts_changed", self, "_on_hearts_changed")


func get_move_to(hex):
	return self.input.move_to(hex)

func take_damage(value: int):
	PlayerStats.take_damage(value)


func _on_player_died() -> void:
	emit_signal("player_died", self)

func _on_hearts_changed(_value) -> void:
	emit_signal("hearts_changed", self)
