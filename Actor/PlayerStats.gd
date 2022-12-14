extends Node2D

"""
Actor stats
[Primary]
	Health
	Stress
[Secondary]
	Fortitude
	Daring
	Smarts
"""

onready var norman = preload("res://Actor/Player/resources/Norman.tres")

func _ready():
	# TODO Replace with character selection
	print_debug("[%s] TODO Replace with character selection" % name)
	set_character(norman)

# Base info
var character: Character setget set_character

signal character_changed(character)

func set_character(new_character: Character) -> void:
	character = new_character
	emit_signal("character_changed", new_character)
	
	# Set all the character stats
	# Primary stats
	set_max_hearts(new_character.max_hp)
	set_current_hearts(new_character.max_hp)
	set_current_stress(0)
	# Secondary stats
	set_fortitude(new_character.fortitude)
	set_fortitude_boost(0)
	set_daring(new_character.daring)
	set_daring_boost(0)
	set_smarts(new_character.smarts)
	set_smarts_boost(0)
	# Reset inventory too
	PlayerInventory.ammo = 0
	PlayerInventory.money = 0
	PlayerInventory.clear_inventory()
	for item in character.items:
		PlayerInventory.add_item(item)

# Primary stats
var current_hearts: int = 5 setget set_current_hearts
var max_hearts: int = 5 setget set_max_hearts
var current_stress: int = 0 setget set_current_stress
var max_stress: int = 6 setget set_max_stress

signal hearts_changed(value)
signal max_hearts_changed(value)
signal stress_changed(value)
signal max_stress_changed(value)

func set_current_hearts(value: int) -> void:
	current_hearts = int(clamp(value, 0, max_hearts))
	emit_signal("hearts_changed", current_hearts)

func set_max_hearts(value: int) -> void:
	max_hearts = int(max(1, value))
	emit_signal("max_hearts_changed", max_hearts)

func set_current_stress(value: int) -> void:
	current_stress = int(clamp(value, 0, max_stress))
	emit_signal("stress_changed", current_stress)

func set_max_stress(value: int) -> void:
	max_stress = int(max(1, value))
	emit_signal("max_stress_changed", max_stress)

# Secondary stats
var fortitude: int = 1 setget set_fortitude
var daring: int = 1 setget set_daring
var smarts: int = 1 setget set_smarts

var base_fortitude: int = 1
var base_daring: int = 1
var base_smarts: int = 1

# Temporary stat boosts (dissapear after the next stat challenge)
var fortitude_boost: int = 0 setget set_fortitude_boost
var daring_boost: int = 0 setget set_daring_boost
var smarts_boost: int = 0 setget set_smarts_boost

signal player_died

func take_damage(damage: int) -> void:
	print(">> %s takes %s damage" % [character.name, damage])
	self.current_hearts -= damage
	if current_hearts <= 0: on_death()

func on_death() -> void:
	print(">> %s died" % character.name)
	emit_signal("player_died", self)
	TheTown.game_over()
	# TODO Swap out texture and portrait
	print_debug("[%s] TODO Handle game over state change" % name)

signal fortitude_changed(value)
signal daring_changed(value)
signal smarts_changed(value)
signal fortitude_boost_changed(value)
signal daring_boost_changed(value)
signal smarts_boost_changed(value)

func set_fortitude(value: int) -> void:
	base_fortitude = value
	fortitude = value + fortitude_boost
	emit_signal("fortitude_changed", fortitude)

func set_daring(value: int) -> void:
	base_daring = value
	daring = value + daring_boost
	emit_signal("daring_changed", daring)

func set_smarts(value: int) -> void:
	base_smarts = value
	smarts = value + smarts_boost
	emit_signal("smarts_changed", smarts)

func set_fortitude_boost(value: int) -> void:
	fortitude_boost = value
	fortitude = base_fortitude + value
	emit_signal("fortitude_changed", fortitude)
	emit_signal("fortitude_boost_changed", fortitude_boost)

func set_daring_boost(value: int) -> void:
	daring_boost = value
	daring = base_daring + value
	emit_signal("daring_changed", daring)
	emit_signal("daring_boost_changed", daring_boost)

func set_smarts_boost(value: int) -> void:
	smarts_boost = value
	smarts = base_smarts + value
	emit_signal("smarts_changed", smarts)
	emit_signal("smarts_boost_changed", smarts_boost)

func get_damage() -> int:
	# Trigger the weapon effect first for possible additional damage calculations
	PlayerInventory.get_current_weapon().get_effect()
	
	var weapon_damage: int = PlayerInventory.get_current_weapon().damage
	print("Damage: " + str(weapon_damage))
	return weapon_damage

func get_reduction() -> int:
	# Trigger the weapon effect first for possible additional reduction calculations
	PlayerInventory.get_current_weapon().get_effect()
	
	var reduction: int = PlayerInventory.get_current_weapon().reduction
	print("Reduction: " + str(reduction) + "%")
	return reduction
